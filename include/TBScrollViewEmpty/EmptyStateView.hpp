#pragma once
#include "EmptyStateOptions.hpp"
#include "EmptyStateSnapshot.hpp"
#include <QWidget>

class QLabel;
class QPushButton;
class QProgressBar;

namespace tbempty {
// Presentation only; the host controls page visibility.
class EmptyStateView final : public QWidget {
    Q_OBJECT
public:
    explicit EmptyStateView(QWidget* parent = nullptr);
    void apply(const EmptyStateSnapshot& snapshot, const EmptyStateOptions& options);

signals:
    void retryClicked();

private:
    QLabel* image_;
    QLabel* title_;
    QLabel* detail_;
    QPushButton* retry_;
    QProgressBar* progress_;
};
}
