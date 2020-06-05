#include <TBScrollViewEmpty/EmptyStateController.hpp>
#include <QSignalSpy>
#include <QtTest>
#include <stdexcept>

class ControllerTest : public QObject {
    Q_OBJECT
private slots:
    void initialState() {
        tbempty::EmptyStateController c;
        QCOMPARE(c.current().kind, tbempty::EmptyStateKind::Content);
        QCOMPARE(c.current().itemCount, 0);
    }
    void updatesAndDeduplication() {
        tbempty::EmptyStateController c;
        QSignalSpy spy(&c, &tbempty::EmptyStateController::stateChanged);
        c.update(0, tbempty::NetworkStatus::Online);
        c.update(0, tbempty::NetworkStatus::Online);
        QCOMPARE(spy.count(), 1);
        QCOMPARE(c.current().kind, tbempty::EmptyStateKind::Empty);
        c.update(1, tbempty::NetworkStatus::Offline);
        QCOMPARE(c.current().kind, tbempty::EmptyStateKind::Content);
        c.update(2, tbempty::NetworkStatus::Offline);
        QCOMPARE(spy.count(), 3); // Item count is part of the snapshot.
        const auto snapshot = qvariant_cast<tbempty::EmptyStateSnapshot>(spy.last().at(0));
        QCOMPARE(snapshot.itemCount, 2);
    }
    void rejectedInputDoesNotMutateState() {
        tbempty::EmptyStateController c;
        c.update(3);
        const auto before = c.current();
        QVERIFY_EXCEPTION_THROWN(c.update(-1), std::invalid_argument);
        QVERIFY_EXCEPTION_THROWN(c.update(0, static_cast<tbempty::NetworkStatus>(77)), std::invalid_argument);
        QVERIFY(c.current() == before);
    }
    void retryDoesNotChangeState() {
        tbempty::EmptyStateController c;
        QSignalSpy retries(&c, &tbempty::EmptyStateController::retryRequested);
        c.setError(QStringLiteral("failed"));
        c.requestRetry();
        c.requestRetry();
        QCOMPARE(retries.count(), 2);
        QCOMPARE(c.current().kind, tbempty::EmptyStateKind::Error);
    }
};
QTEST_GUILESS_MAIN(ControllerTest)
#include "tst_controller.moc"
