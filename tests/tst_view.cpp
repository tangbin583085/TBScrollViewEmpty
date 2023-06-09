#include <TBScrollViewEmpty/EmptyStateView.hpp>
#include <QLabel>
#include <QProgressBar>
#include <QPushButton>
#include <QSignalSpy>
#include <QtTest>

class ViewTest : public QObject {
    Q_OBJECT
private slots:
    void fallbackIconSizeAndTextRefresh() {
        tbempty::EmptyStateView view;
        tbempty::EmptyStateOptions options;
        options.iconSize = QSize(0, 0);
        const auto state = tbempty::EmptyStateSnapshot{
            tbempty::EmptyStateKind::Empty, 0, tbempty::NetworkStatus::Unknown, {}};
        view.apply(state, options);
        auto* image = view.findChild<QLabel*>(QStringLiteral("tbempty.image"));
        auto* title = view.findChild<QLabel*>(QStringLiteral("tbempty.title"));
        QVERIFY(image && title);
        QVERIFY(!image->isHidden());
        options.emptyTitle = QStringLiteral("Changed title");
        view.apply(state, options);
        QCOMPARE(title->text(), options.emptyTitle);
        QCOMPARE(view.accessibleName(), options.emptyTitle);
    }
    void visibilityTracksState() {
        tbempty::EmptyStateView view;
        const tbempty::EmptyStateOptions options;
        auto* retry = view.findChild<QPushButton*>(QStringLiteral("tbempty.retry"));
        auto* progress = view.findChild<QProgressBar*>(QStringLiteral("tbempty.progress"));
        auto* image = view.findChild<QLabel*>(QStringLiteral("tbempty.image"));
        QVERIFY(retry && progress && image);
        for (auto kind : {tbempty::EmptyStateKind::Empty, tbempty::EmptyStateKind::Offline,
                          tbempty::EmptyStateKind::Error}) {
            view.apply({kind, 0, tbempty::NetworkStatus::Unknown, {}}, options);
            QVERIFY(!retry->isHidden());
            QVERIFY(progress->isHidden());
            QVERIFY(!image->isHidden());
        }
        view.apply({tbempty::EmptyStateKind::Loading, 0, tbempty::NetworkStatus::Unknown, {}}, options);
        QVERIFY(retry->isHidden());
        QVERIFY(!progress->isHidden());
        QVERIFY(image->isHidden());
        view.apply({}, options);
        QVERIFY(retry->isHidden());
        QVERIFY(progress->isHidden());
    }
    void retrySignalAndAccessibility() {
        tbempty::EmptyStateView view;
        tbempty::EmptyStateOptions options;
        options.emptyTitle = QStringLiteral("No items");
        view.apply({tbempty::EmptyStateKind::Empty, 0, tbempty::NetworkStatus::Unknown, {}}, options);
        QSignalSpy spy(&view, &tbempty::EmptyStateView::retryClicked);
        auto* retry = view.findChild<QPushButton*>(QStringLiteral("tbempty.retry"));
        QVERIFY(retry);
        retry->click();
        QCOMPARE(spy.count(), 1);
        QCOMPARE(view.accessibleName(), QStringLiteral("No items"));
        options.showRetryButton = false;
        view.apply({tbempty::EmptyStateKind::Empty, 0, tbempty::NetworkStatus::Unknown, {}}, options);
        QVERIFY(retry->isHidden());
    }
};
QTEST_MAIN(ViewTest)
#include "tst_view.moc"
