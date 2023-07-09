#include <TBScrollViewEmpty/TBScrollViewEmpty.hpp>
#include <QApplication>
#include <QListView>

int main(int argc, char** argv) {
    QApplication app(argc, argv);
    tbempty::EmptyStateHost host(new QListView);
    host.controller()->update(0);
    host.resize(500, 320);
    host.show();
    return app.exec();
}
