#pragma once
#include <TBScrollViewEmpty/TBScrollViewEmpty.hpp>
#include <QHBoxLayout>
#include <QPushButton>
#include <functional>

inline void addStateButtons(QVBoxLayout* layout, tbempty::EmptyStateHost* host,
                            const std::function<void()>& fill,
                            const std::function<void()>& clear) {
    auto* buttons = new QHBoxLayout;
    layout->addLayout(buttons);
    const auto add = [buttons, host](const QString& text, std::function<void()> action) {
        auto* button = new QPushButton(text);
        buttons->addWidget(button);
        QObject::connect(button, &QPushButton::clicked, host, std::move(action));
    };
    add(QStringLiteral("Content"), fill);
    add(QStringLiteral("Empty"), [host, clear] {
        clear();
        host->controller()->update(0, tbempty::NetworkStatus::Online);
    });
    add(QStringLiteral("Loading"), [host] { host->controller()->setLoading(); });
    add(QStringLiteral("Offline"), [host, clear] {
        clear();
        host->controller()->update(0, tbempty::NetworkStatus::Offline);
    });
    add(QStringLiteral("Error"), [host] {
        host->controller()->setError(QStringLiteral("Device did not respond"));
    });
}
