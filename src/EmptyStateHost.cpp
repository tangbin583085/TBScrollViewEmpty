#include <TBScrollViewEmpty/EmptyStateHost.hpp>
#include <TBScrollViewEmpty/EmptyStateView.hpp>
#include <QStackedLayout>
#include <stdexcept>
#include <utility>

namespace tbempty {
EmptyStateHost::EmptyStateHost(QWidget* content, EmptyStateOptions options, QWidget* parent)
    : QWidget(parent), options_(std::move(options)),
      controller_(new EmptyStateController(this)), stack_(new QStackedLayout(this)),
      default_(new EmptyStateView(this)), content_(content) {
    if (!content || content == parent || content->isAncestorOf(this))
        throw std::invalid_argument("content must be a widget other than the host's ancestors");
    // addWidget reparents content; the caller must not pass a stack-allocated widget.
    stack_->setContentsMargins(0, 0, 0, 0);
    stack_->setStackingMode(QStackedLayout::StackOne);
    stack_->addWidget(content);
    stack_->addWidget(default_);
    connect(default_, &EmptyStateView::retryClicked, controller_, &EmptyStateController::requestRetry);
    connect(controller_, &EmptyStateController::retryRequested, this, &EmptyStateHost::retryRequested);
    connect(controller_, &EmptyStateController::stateChanged, this,
            [this](EmptyStateSnapshot snapshot) {
        refresh();
        emit stateChanged(snapshot);
    });
    contentDestroyed_ = connect(content, &QObject::destroyed, this, [this] {
        content_.clear();
        refresh();
    });
    refresh();
}
EmptyStateHost::~EmptyStateHost() {
    disconnect(customDestroyed_);
    disconnect(contentDestroyed_);
    disconnect(controller_, nullptr, this, nullptr);
}
void EmptyStateHost::setOptions(EmptyStateOptions options) {
    options_ = std::move(options);
    refresh();
}
QWidget* EmptyStateHost::takeCustomView() {
    auto* previous = custom_.data();
    if (!previous) return nullptr;
    disconnect(customDestroyed_);
    custom_.clear();
    // Child buttons can also be connected to the host/controller. Disconnect them
    // when releasing the page so a queued deletion cannot trigger a stale retry.
    auto senders = previous->findChildren<QObject*>();
    senders.append(previous);
    for (auto* sender : senders) {
        QObject::disconnect(sender, nullptr, controller_, nullptr);
        QObject::disconnect(sender, nullptr, this, nullptr);
        QObject::disconnect(controller_, nullptr, sender, nullptr);
        QObject::disconnect(this, nullptr, sender, nullptr);
    }
    stack_->removeWidget(previous);
    previous->hide();
    previous->setParent(nullptr);
    refresh();
    return previous;
}
void EmptyStateHost::setCustomView(QWidget* view) {
    if (view == custom_.data()) return;
    if (view && (view == this || view == content_.data() || view == default_ ||
                 view->isAncestorOf(this) || view->parentWidget()))
        throw std::invalid_argument("custom view must be an unparented widget, not host/content");
    if (auto* previous = takeCustomView()) {
        // Keep it owned until DeferredDelete is delivered, including during shutdown.
        previous->setParent(this);
        previous->deleteLater();
    }
    if (view) {
        custom_ = view;
        stack_->addWidget(view);
        customDestroyed_ = connect(view, &QObject::destroyed, this, [this] {
            custom_.clear();
            refresh();
        });
    }
    refresh();
}
void EmptyStateHost::refresh() {
    auto snapshot = controller_->current();
    // If content was deleted by its caller, keep the host safe and show the empty page.
    if (snapshot.kind == EmptyStateKind::Content && !content_) snapshot.kind = EmptyStateKind::Empty;
    default_->apply(snapshot, options_);
    if (snapshot.kind == EmptyStateKind::Content && content_) {
        stack_->setCurrentWidget(content_);
    } else {
        stack_->setCurrentWidget(custom_ ? custom_.data() : default_);
    }
}
}
