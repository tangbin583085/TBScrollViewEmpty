#include <TBScrollViewEmpty/TBScrollViewEmpty.hpp>
#include <QListView>
#include <QPushButton>
#include <QSignalSpy>
#include <QStackedLayout>
#include <QtTest>

class HostTest : public QObject {
    Q_OBJECT
private slots:
    void swapsContentAndDefault() {
        auto* content = new QListView;
        tbempty::EmptyStateHost host(content);
        auto* stack = qobject_cast<QStackedLayout*>(host.layout());
        auto* view = host.findChild<tbempty::EmptyStateView*>();
        QVERIFY(stack && view);
        QCOMPARE(stack->currentWidget(), content);
        host.controller()->update(0);
        QCOMPARE(stack->currentWidget(), view);
        QVERIFY(content->isHidden());
        host.controller()->update(2);
        QCOMPARE(stack->currentWidget(), content);
        QVERIFY(view->isHidden());
    }
    void customViewAndRetry() {
        tbempty::EmptyStateHost host(new QWidget);
        auto* custom = new QWidget;
        host.setCustomView(custom);
        host.controller()->setError();
        auto* stack = qobject_cast<QStackedLayout*>(host.layout());
        QVERIFY(stack);
        QCOMPARE(stack->currentWidget(), custom);
        host.setCustomView(nullptr);
        QCOMPARE(stack->currentWidget(), host.findChild<tbempty::EmptyStateView*>());
        QSignalSpy spy(&host, &tbempty::EmptyStateHost::retryRequested);
        auto* retry = host.findChild<QPushButton*>(QStringLiteral("tbempty.retry"));
        QVERIFY(retry);
        retry->click();
        QCOMPARE(spy.count(), 1);
    }
    void followsHostSize() {
        tbempty::EmptyStateHost host(new QWidget);
        host.controller()->setLoading();
        host.resize(620, 410);
        host.show();
        QCoreApplication::processEvents();
        auto* stack = qobject_cast<QStackedLayout*>(host.layout());
        QVERIFY(stack);
        QCOMPARE(stack->currentWidget()->size(), host.contentsRect().size());
    }
};
QTEST_MAIN(HostTest)
#include "tst_host.moc"
