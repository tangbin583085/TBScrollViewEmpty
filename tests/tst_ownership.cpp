#include <TBScrollViewEmpty/TBScrollViewEmpty.hpp>
#include <QPointer>
#include <QStackedLayout>
#include <QPushButton>
#include <QSignalSpy>
#include <QtTest>
#include <stdexcept>

class OwnershipTest : public QObject {
    Q_OBJECT
private slots:
    void replacedPageIsOwnedUntilDeferredDeletion() {
        QPointer<QWidget> oldPage = new QWidget;
        {
            tbempty::EmptyStateHost host(new QWidget);
            host.setCustomView(oldPage);
            host.setCustomView(new QWidget);
            QVERIFY(oldPage && oldPage->parent() == &host);
        }
        QVERIFY(oldPage.isNull());
    }
    void invalidContentIsRejected() {
        QVERIFY_EXCEPTION_THROWN(tbempty::EmptyStateHost(nullptr), std::invalid_argument);
        QWidget parent;
        QVERIFY_EXCEPTION_THROWN((tbempty::EmptyStateHost(&parent, {}, &parent)), std::invalid_argument);
    }
    void releasedChildButtonsCannotRetryTheHost() {
        tbempty::EmptyStateHost host(new QWidget);
        auto* custom = new QWidget;
        auto* button = new QPushButton(custom);
        connect(button, &QPushButton::clicked,
                host.controller(), &tbempty::EmptyStateController::requestRetry);
        int customNotifications = 0;
        connect(&host, &tbempty::EmptyStateHost::stateChanged, custom,
                [&customNotifications] { ++customNotifications; });
        host.setCustomView(custom);
        QSignalSpy retries(&host, &tbempty::EmptyStateHost::retryRequested);
        button->click();
        QCOMPARE(retries.count(), 1);
        auto* taken = host.takeCustomView();
        button->click();
        QCOMPARE(retries.count(), 1);
        host.controller()->setLoading();
        QCOMPARE(customNotifications, 0);
        delete taken;
    }
    void replacementDeletesOldWidgetLater() {
        tbempty::EmptyStateHost host(new QWidget);
        QPointer<QWidget> first = new QWidget;
        host.setCustomView(first);
        host.setCustomView(first);
        QCOMPARE(host.customView(), first.data());
        host.setCustomView(new QWidget);
        QVERIFY(first && first->isHidden());
        QCoreApplication::sendPostedEvents(nullptr, QEvent::DeferredDelete);
        QVERIFY(first.isNull());
    }
    void takeReleasesOwnership() {
        tbempty::EmptyStateHost host(new QWidget);
        auto* custom = new QWidget;
        host.setCustomView(custom);
        host.controller()->setEmpty();
        auto* taken = host.takeCustomView();
        QCOMPARE(taken, custom);
        QVERIFY(!taken->parent());
        QVERIFY(taken->isHidden());
        QVERIFY(!host.customView());
        delete taken;
    }
    void invalidWidgetsAreRejectedWithoutChangingCurrentView() {
        tbempty::EmptyStateHost host(new QWidget);
        auto* custom = new QWidget;
        host.setCustomView(custom);
        QVERIFY_EXCEPTION_THROWN(host.setCustomView(&host), std::invalid_argument);
        QVERIFY_EXCEPTION_THROWN(host.setCustomView(host.contentWidget()), std::invalid_argument);
        QWidget other;
        QWidget child(&other);
        QVERIFY_EXCEPTION_THROWN(host.setCustomView(&child), std::invalid_argument);
        QCOMPARE(host.customView(), custom);
    }
    void externalDeletionFallsBackSafely() {
        tbempty::EmptyStateHost host(new QWidget);
        auto* custom = new QWidget;
        host.setCustomView(custom);
        host.controller()->setEmpty();
        delete custom;
        QVERIFY(!host.customView());
        auto* stack = qobject_cast<QStackedLayout*>(host.layout());
        QVERIFY(stack);
        QCOMPARE(stack->currentWidget(), host.findChild<tbempty::EmptyStateView*>());
        host.controller()->setContent();
        delete host.contentWidget();
        QVERIFY(!host.contentWidget());
        QCOMPARE(stack->currentWidget(), host.findChild<tbempty::EmptyStateView*>());
    }
    void hostDeletesItsWidgets() {
        QPointer<QWidget> content = new QWidget;
        QPointer<QWidget> custom = new QWidget;
        {
            tbempty::EmptyStateHost host(content);
            host.setCustomView(custom);
        }
        QVERIFY(content.isNull());
        QVERIFY(custom.isNull());
    }
};
QTEST_MAIN(OwnershipTest)
#include "tst_ownership.moc"
