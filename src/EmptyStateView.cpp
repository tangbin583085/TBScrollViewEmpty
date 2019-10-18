#include <TBScrollViewEmpty/EmptyStateView.hpp>
#include <QLabel>
#include <QProgressBar>
#include <QPushButton>
#include <QStyle>
#include <QVBoxLayout>

namespace tbempty {
EmptyStateView::EmptyStateView(QWidget* parent) : QWidget(parent),
    image_(new QLabel(this)), title_(new QLabel(this)), detail_(new QLabel(this)),
    retry_(new QPushButton(this)), progress_(new QProgressBar(this)) {
    setObjectName(QStringLiteral("tbempty.defaultView"));
    image_->setObjectName(QStringLiteral("tbempty.image"));
    title_->setObjectName(QStringLiteral("tbempty.title"));
    detail_->setObjectName(QStringLiteral("tbempty.detail"));
    retry_->setObjectName(QStringLiteral("tbempty.retry"));
    progress_->setObjectName(QStringLiteral("tbempty.progress"));
    for (auto* label : {image_, title_, detail_}) {
        label->setAlignment(Qt::AlignCenter);
        label->setTextFormat(Qt::PlainText);
    }
    title_->setWordWrap(true);
    detail_->setWordWrap(true);
    auto font = title_->font();
    font.setBold(true);
    title_->setFont(font);
    progress_->setRange(0, 0);
    progress_->setTextVisible(false);
    progress_->setMaximumWidth(180);
    auto* layout = new QVBoxLayout(this);
    layout->setContentsMargins(24, 24, 24, 24);
    layout->setSpacing(12);
    layout->addStretch();
    layout->addWidget(image_);
    layout->addWidget(progress_, 0, Qt::AlignHCenter);
    layout->addWidget(title_);
    layout->addWidget(detail_);
    layout->addWidget(retry_, 0, Qt::AlignHCenter);
    layout->addStretch();
    connect(retry_, &QPushButton::clicked, this, &EmptyStateView::retryClicked);
    apply({}, {});
}

void EmptyStateView::apply(const EmptyStateSnapshot& snapshot, const EmptyStateOptions& options) {
    QString title;
    QString detail;
    switch (snapshot.kind) {
    case EmptyStateKind::Content: break;
    case EmptyStateKind::Loading: title = options.loadingTitle; break;
    case EmptyStateKind::Empty:
        title = options.emptyTitle; detail = options.emptyDetail; break;
    case EmptyStateKind::Offline:
        title = options.offlineTitle; detail = options.offlineDetail; break;
    case EmptyStateKind::Error:
        title = options.errorTitle;
        detail = snapshot.errorMessage.isEmpty() ? options.errorDetail : snapshot.errorMessage;
        break;
    }
    title_->setText(title);
    title_->setAccessibleName(title);
    detail_->setText(detail);
    detail_->setVisible(!detail.isEmpty());
    setAccessibleName(title);
    setAccessibleDescription(detail);
    retry_->setText(options.retryButtonText);
    retry_->setAccessibleName(options.retryButtonText);
    const bool retryable = snapshot.kind == EmptyStateKind::Empty ||
                          snapshot.kind == EmptyStateKind::Offline ||
                          snapshot.kind == EmptyStateKind::Error;
    retry_->setVisible(options.showRetryButton && retryable);
    progress_->setVisible(snapshot.kind == EmptyStateKind::Loading);
    const auto icon = options.icon.isNull() ? style()->standardIcon(QStyle::SP_MessageBoxInformation)
                                           : options.icon;
    const auto size = options.iconSize.isValid() && !options.iconSize.isEmpty()
                    ? options.iconSize : QSize(64, 64);
    image_->setPixmap(icon.pixmap(size));
    image_->setVisible(options.showImage && snapshot.kind != EmptyStateKind::Loading &&
                       snapshot.kind != EmptyStateKind::Content);
}
}
