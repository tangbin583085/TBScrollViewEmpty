#pragma once
#include "EmptyStateKind.hpp"
#include "NetworkStatus.hpp"
#include <QString>

namespace tbempty {
struct EmptyStateSnapshot {
    EmptyStateKind kind = EmptyStateKind::Content;
    int itemCount = 0;
    NetworkStatus network = NetworkStatus::Unknown;
    QString errorMessage;
};
inline bool operator==(const EmptyStateSnapshot& a, const EmptyStateSnapshot& b) {
    return a.kind == b.kind && a.itemCount == b.itemCount &&
           a.network == b.network && a.errorMessage == b.errorMessage;
}
inline bool operator!=(const EmptyStateSnapshot& a, const EmptyStateSnapshot& b) {
    return !(a == b);
}
}
Q_DECLARE_METATYPE(tbempty::EmptyStateSnapshot)
