#include <TBScrollViewEmpty/TBScrollViewEmpty.hpp>
#include <QLabel>
#include <QPushButton>
#include <QtTest>

class OptionsTest : public QObject {
    Q_OBJECT
private slots:
    void optionsRefreshWithoutChangingState() {
        tbempty::EmptyStateHost host(new QWidget);
        host.controller()->setEmpty();
        auto options = host.options();
        options.emptyTitle = QStringLiteral("Nothing here");
        options.emptyDetail.clear();
        options.retryButtonText = QStringLiteral("Reload");
        options.showImage = false;
        host.setOptions(options);
        auto* title = host.findChild<QLabel*>(QStringLiteral("tbempty.title"));
        auto* detail = host.findChild<QLabel*>(QStringLiteral("tbempty.detail"));
        auto* image = host.findChild<QLabel*>(QStringLiteral("tbempty.image"));
        auto* retry = host.findChild<QPushButton*>(QStringLiteral("tbempty.retry"));
        QVERIFY(title && detail && image && retry);
        QCOMPARE(title->text(), QStringLiteral("Nothing here"));
        QVERIFY(detail->isHidden());
        QVERIFY(image->isHidden());
        QCOMPARE(retry->text(), QStringLiteral("Reload"));
        QCOMPARE(host.controller()->current().kind, tbempty::EmptyStateKind::Empty);
        options.emptyTitle = QStringLiteral("Not applied");
        QCOMPARE(title->text(), QStringLiteral("Nothing here"));
    }
    void errorUsesCustomMessageOrFallback() {
        tbempty::EmptyStateHost host(new QWidget);
        auto* detail = host.findChild<QLabel*>(QStringLiteral("tbempty.detail"));
        QVERIFY(detail);
        host.controller()->setError(QStringLiteral("<b>Device failed</b>"));
        QCOMPARE(detail->textFormat(), Qt::PlainText);
        QCOMPARE(detail->text(), QStringLiteral("<b>Device failed</b>"));
        host.controller()->setError();
        QCOMPARE(detail->text(), host.options().errorDetail);
    }
};
QTEST_MAIN(OptionsTest)
#include "tst_options.moc"
