# TBScrollViewEmpty

一个 C++17 / Qt Widgets 列表状态组件。列表没有数据、正在加载、离线或请求失败时，用统一的提示页替换内容区域；有数据时恢复列表。

适合 Qt 上位机中的设备列表、记录表格等页面。支持 QListView、QTableView、QTreeView，也可以包装其他 QWidget。组件不请求网络、不检测连接状态，也不修改数据模型。

## 功能

- Content、Loading、Empty、Offline、Error 五种状态。
- 自定义标题、详情、图标、重试按钮文字和显示开关。
- 点击重试后发出信号，业务层决定如何加载。
- 支持自定义 QWidget 提示页，或恢复默认视图。
- 相同快照不重复通知；返回的快照是独立的值。
- 使用 Qt 布局适应窗口大小，支持键盘操作和基本无障碍文字。

## 添加到工程

需要已有的 C++17 编译器、CMake 3.16+、Qt 5.15 或 Qt 6 Widgets 环境。核心控制器只链接 Qt Core；界面组件链接 Qt Widgets。本仓库默认构建这两个目标。

把源码放入工程后：

```cmake
add_subdirectory(third_party/TBScrollViewEmpty)
target_link_libraries(MyApp PRIVATE TBScrollViewEmpty::Widgets)
```

构建示例和测试的命令见 [构建说明](docs/building.md)。现有 qmake 工程可参考 [qmake 接入](docs/qmake.md)。不会自动下载或安装 Qt。

## 简单使用

```cpp
#include <TBScrollViewEmpty/TBScrollViewEmpty.hpp>
#include <QListView>
#include <QVBoxLayout>

auto* list = new QListView;
list->setModel(model); // model 是业务项目维护的数据模型

tbempty::EmptyStateOptions options;
options.emptyTitle = QStringLiteral("还没有设备");
options.emptyDetail = QStringLiteral("连接设备后会显示在这里");
options.retryButtonText = QStringLiteral("重新扫描");

auto* host = new tbempty::EmptyStateHost(list, options);
layout->addWidget(host); // layout 是页面的布局

QObject::connect(host, &tbempty::EmptyStateHost::retryRequested,
                 host, [host] {
    host->controller()->setLoading();
    // 在这里启动异步加载，完成后回到 GUI 线程更新模型和状态。
});

host->controller()->update(model->rowCount(), tbempty::NetworkStatus::Online);
```

`model` 和 `layout` 由你的页面创建。组件不会自动监听模型，数据变化后需要显式调用 `update`。
