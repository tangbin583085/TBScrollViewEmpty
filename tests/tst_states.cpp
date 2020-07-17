#include <TBScrollViewEmpty/EmptyStateController.hpp>
#include <QSignalSpy>
#include <QtTest>

class StatesTest : public QObject {
    Q_OBJECT
private slots:
    void emptyAndOffline() {
        tbempty::EmptyStateController c;
        c.update(0);
        QCOMPARE(c.current().kind, tbempty::EmptyStateKind::Empty);
        c.update(0, tbempty::NetworkStatus::Offline);
        QCOMPARE(c.current().kind, tbempty::EmptyStateKind::Offline);
        c.update(5, tbempty::NetworkStatus::Offline);
        QCOMPARE(c.current().kind, tbempty::EmptyStateKind::Content);
    }
    void explicitStatesKeepMetadata() {
        tbempty::EmptyStateController c;
        c.update(7, tbempty::NetworkStatus::Online);
        c.setLoading();
        QCOMPARE(c.current().itemCount, 7);
        QCOMPARE(c.current().kind, tbempty::EmptyStateKind::Loading);
        c.setError(QStringLiteral("timeout"));
        QCOMPARE(c.current().errorMessage, QStringLiteral("timeout"));
        c.setOffline();
        QCOMPARE(c.current().network, tbempty::NetworkStatus::Offline);
        QVERIFY(c.current().errorMessage.isEmpty());
        c.setEmpty();
        QCOMPARE(c.current().kind, tbempty::EmptyStateKind::Empty);
        c.setContent();
        QCOMPARE(c.current().kind, tbempty::EmptyStateKind::Content);
    }
    void changedErrorMessageEmits() {
        tbempty::EmptyStateController c;
        QSignalSpy spy(&c, &tbempty::EmptyStateController::stateChanged);
        c.setError(QStringLiteral("one"));
        c.setError(QStringLiteral("one"));
        c.setError(QStringLiteral("two"));
        QCOMPARE(spy.count(), 2);
        c.update(0);
        QVERIFY(c.current().errorMessage.isEmpty());
    }
    void queuedSnapshotRemainsAValue() {
        tbempty::EmptyStateController c;
        QObject receiver;
        QList<tbempty::EmptyStateSnapshot> received;
        connect(&c, &tbempty::EmptyStateController::stateChanged, &receiver,
            [&received](tbempty::EmptyStateSnapshot state) { received.push_back(state); },
            Qt::QueuedConnection);
        c.setError(QStringLiteral("first"));
        c.setLoading();
        QTRY_COMPARE(received.size(), 2);
        QCOMPARE(received[0].errorMessage, QStringLiteral("first"));
        QCOMPARE(received[1].kind, tbempty::EmptyStateKind::Loading);
    }
};
QTEST_GUILESS_MAIN(StatesTest)
#include "tst_states.moc"
