#pragma once
#include <QMetaType>

namespace tbempty {
enum class NetworkStatus { Unknown, Online, Offline };
}
Q_DECLARE_METATYPE(tbempty::NetworkStatus)
