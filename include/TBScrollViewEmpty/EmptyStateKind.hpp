#pragma once
#include <QMetaType>

namespace tbempty {
enum class EmptyStateKind { Content, Loading, Empty, Offline, Error };
}
Q_DECLARE_METATYPE(tbempty::EmptyStateKind)
