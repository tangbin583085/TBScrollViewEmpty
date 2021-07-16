#include <TBScrollViewEmpty/TBScrollViewEmpty.hpp>
#include <QApplication>
#include <QLabel>
#include <QListWidget>
#include <QPushButton>
#include <QVBoxLayout>

int main(int argc, char** argv) {
    QApplication app(argc, argv);
    QWidget window;
    auto* layout = new QVBoxLayout(&window);
    auto* list = new QListWidget;
    auto* host = new tbempty::EmptyStateHost(list);
    layout->addWidget(host);

    auto* custom = new QWidget;
    auto* customLayout = new QVBoxLayout(custom);
    auto* label = new QLabel(QStringLiteral("No devices found"), custom);
    label->setAlignment(Qt::AlignCenter);
    auto* scan = new QPushButton(QStringLiteral("Scan devices"), custom);
    customLayout->addStretch();
    customLayout->addWidget(label);
    customLayout->addWidget(scan);
    customLayout->addStretch();
    QObject::connect(scan, &QPushButton::clicked,
                     host->controller(), &tbempty::EmptyStateController::requestRetry);
    host->setCustomView(custom);
    QObject::connect(host, &tbempty::EmptyStateHost::retryRequested, host, [host, list] {
        list->addItem(QStringLiteral("Device 1"));
        host->controller()->update(list->count(), tbempty::NetworkStatus::Online);
    });
    auto* restore = new QPushButton(QStringLiteral("Use default empty view"), &window);
    layout->addWidget(restore);
    QObject::connect(restore, &QPushButton::clicked, host, [host, list] {
        host->setCustomView(nullptr);
        list->clear();
        host->controller()->update(0);
    });
    host->controller()->update(0);
    window.resize(560, 360);
    window.show();
    return app.exec();
}
