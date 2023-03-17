#include <QApplication>
#include <QListView>
#include <QStringListModel>
#include <QTimer>
#include <QVBoxLayout>
#include "StateButtons.hpp"

int main(int argc, char** argv) {
    QApplication app(argc, argv);
    QWidget window;
    window.setWindowTitle(QStringLiteral("TBScrollViewEmpty - list"));
    auto* layout = new QVBoxLayout(&window);
    auto* list = new QListView;
    auto* model = new QStringListModel(list);
    list->setModel(model);
    auto* host = new tbempty::EmptyStateHost(list);
    layout->addWidget(host);
    const auto fill = [host, model] {
        model->setStringList({QStringLiteral("Device A"), QStringLiteral("Device B")});
        host->controller()->update(model->rowCount(), tbempty::NetworkStatus::Online);
    };
    const auto clear = [model] { model->setStringList({}); };
    addStateButtons(layout, host, fill, clear);
    auto* retryTimer = new QTimer(host);
    retryTimer->setSingleShot(true);
    QObject::connect(retryTimer, &QTimer::timeout, host, fill);
    QObject::connect(host, &tbempty::EmptyStateHost::stateChanged, retryTimer,
                     [retryTimer](tbempty::EmptyStateSnapshot state) {
        if (state.kind != tbempty::EmptyStateKind::Loading) retryTimer->stop();
    });
    QObject::connect(host, &tbempty::EmptyStateHost::retryRequested, host, [host, retryTimer] {
        host->controller()->setLoading();
        retryTimer->start(500);
    });
    host->controller()->update(0);
    window.resize(680, 440);
    window.show();
    return app.exec();
}
