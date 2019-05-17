#include <TBScrollViewEmpty/EmptyStateController.hpp>
#include <stdexcept>

namespace tbempty {
EmptyStateController::EmptyStateController(QObject* parent) : QObject(parent) {
    qRegisterMetaType<tbempty::EmptyStateSnapshot>("tbempty::EmptyStateSnapshot");
    qRegisterMetaType<tbempty::NetworkStatus>("tbempty::NetworkStatus");
}
void EmptyStateController::update(int itemCount, NetworkStatus network) {
    if (itemCount < 0) throw std::invalid_argument("itemCount must not be negative");
    if (network != NetworkStatus::Unknown && network != NetworkStatus::Online &&
        network != NetworkStatus::Offline)
        throw std::invalid_argument("unsupported network status");
    EmptyStateSnapshot next;
    next.itemCount = itemCount;
    next.network = network;
    next.kind = itemCount > 0 ? EmptyStateKind::Content
              : network == NetworkStatus::Offline ? EmptyStateKind::Offline
              : EmptyStateKind::Empty;
    if (next == current_) return;
    current_ = next;
    emit stateChanged(next);
}
void EmptyStateController::setState(EmptyStateKind kind, const QString& message) {
    auto next = current_;
    next.kind = kind;
    next.errorMessage = message;
    if (kind == EmptyStateKind::Offline) next.network = NetworkStatus::Offline;
    if (next == current_) return;
    current_ = next;
    emit stateChanged(next);
}
void EmptyStateController::setLoading() { setState(EmptyStateKind::Loading); }
void EmptyStateController::setError(const QString& message) { setState(EmptyStateKind::Error, message); }
void EmptyStateController::setOffline() { setState(EmptyStateKind::Offline); }
void EmptyStateController::setEmpty() { setState(EmptyStateKind::Empty); }
void EmptyStateController::setContent() { setState(EmptyStateKind::Content); }
void EmptyStateController::requestRetry() { emit retryRequested(); }
}
