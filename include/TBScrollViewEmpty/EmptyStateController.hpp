#pragma once
#include "EmptyStateSnapshot.hpp"
#include <QObject>

namespace tbempty {
// Use only from the object's owning thread. No network or model access.
class EmptyStateController final : public QObject {
    Q_OBJECT
public:
    explicit EmptyStateController(QObject* parent = nullptr);
    EmptyStateSnapshot current() const { return current_; }

public slots:
    void update(int itemCount, tbempty::NetworkStatus network = tbempty::NetworkStatus::Unknown);
    void setLoading();
    void setError(const QString& message = {});
    void setOffline();
    void setEmpty();
    void setContent();
    void requestRetry();

signals:
    void stateChanged(tbempty::EmptyStateSnapshot snapshot);
    void retryRequested();

private:
    void setState(EmptyStateKind kind, const QString& errorMessage = {});
    EmptyStateSnapshot current_;
};
}
