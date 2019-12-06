#pragma once
#include "EmptyStateController.hpp"
#include "EmptyStateOptions.hpp"
#include <QPointer>
#include <QWidget>

class QStackedLayout;
namespace tbempty {
class EmptyStateView;

// Owns content and custom widgets. All methods must run on the GUI thread.
class EmptyStateHost final : public QWidget {
    Q_OBJECT
public:
    explicit EmptyStateHost(QWidget* content, EmptyStateOptions options = {},
                            QWidget* parent = nullptr);
    ~EmptyStateHost() override;
    EmptyStateController* controller() const noexcept { return controller_; }
    QWidget* contentWidget() const noexcept { return content_.data(); }
    QWidget* customView() const noexcept { return custom_.data(); }
    EmptyStateOptions options() const { return options_; }
    void setOptions(EmptyStateOptions options);

    // Takes ownership of an unparented heap widget. nullptr restores the default.
    // Replaced custom widgets are hidden, disconnected and deleted later.
    void setCustomView(QWidget* view);
    // Releases ownership without deleting the custom widget; caller must reuse/delete it.
    QWidget* takeCustomView();

signals:
    void stateChanged(tbempty::EmptyStateSnapshot snapshot);
    void retryRequested();

private:
    void refresh();
    EmptyStateOptions options_;
    EmptyStateController* controller_;
    QStackedLayout* stack_;
    EmptyStateView* default_;
    QPointer<QWidget> content_;
    QPointer<QWidget> custom_;
    QMetaObject::Connection customDestroyed_;
    QMetaObject::Connection contentDestroyed_;
};
}
