#include <QApplication>
#include <QHeaderView>
#include <QStandardItemModel>
#include <QTableView>
#include <QVBoxLayout>
#include "StateButtons.hpp"

int main(int argc, char** argv) {
    QApplication app(argc, argv);
    QWidget window;
    window.setWindowTitle(QStringLiteral("TBScrollViewEmpty - table"));
    auto* layout = new QVBoxLayout(&window);
    auto* table = new QTableView;
    auto* model = new QStandardItemModel(0, 2, table);
    model->setHorizontalHeaderLabels({QStringLiteral("Device"), QStringLiteral("Status")});
    table->setModel(model);
    table->horizontalHeader()->setSectionResizeMode(QHeaderView::Stretch);
    auto* host = new tbempty::EmptyStateHost(table);
    layout->addWidget(host);
    const auto fill = [host, model] {
        model->setRowCount(2);
        model->setData(model->index(0, 0), QStringLiteral("Pump"));
        model->setData(model->index(0, 1), QStringLiteral("Ready"));
        model->setData(model->index(1, 0), QStringLiteral("Sensor"));
        model->setData(model->index(1, 1), QStringLiteral("Online"));
        host->controller()->update(model->rowCount(), tbempty::NetworkStatus::Online);
    };
    const auto clear = [model] { model->setRowCount(0); };
    addStateButtons(layout, host, fill, clear);
    QObject::connect(host, &tbempty::EmptyStateHost::retryRequested, host, fill);
    host->controller()->update(0);
    window.resize(720, 440);
    window.show();
    return app.exec();
}
