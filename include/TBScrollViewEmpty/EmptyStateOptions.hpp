#pragma once
#include <QIcon>
#include <QSize>
#include <QString>

namespace tbempty {
struct EmptyStateOptions {
    QString emptyTitle = QStringLiteral("暂时没有数据");
    QString emptyDetail = QStringLiteral("这里暂时没有可以展示的内容");
    QString offlineTitle = QStringLiteral("网络不可用");
    QString offlineDetail = QStringLiteral("请检查网络设置后重试");
    QString errorTitle = QStringLiteral("加载失败");
    QString errorDetail = QStringLiteral("数据加载失败，请稍后重试");
    QString loadingTitle = QStringLiteral("正在加载");
    QString retryButtonText = QStringLiteral("重试");
    bool showImage = true;
    bool showRetryButton = true;
    QIcon icon; // A null icon uses the platform's standard information icon.
    QSize iconSize{64, 64};
};
}
