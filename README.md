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

## 状态

`update(itemCount, network)` 根据输入决定显示内容：

| 条件 | 状态 |
| --- | --- |
| itemCount > 0 | Content，即使网络离线也显示已有数据 |
| itemCount == 0 且 Offline | Offline |
| itemCount == 0 且 Online / Unknown | Empty |

也可以手动切换：

```cpp
host->controller()->setLoading();
host->controller()->setError(QStringLiteral("设备暂时没有响应"));
host->controller()->setOffline();
host->controller()->setEmpty();
host->controller()->setContent();
```

手动切换不改变上次记录的数据数量；`setOffline()` 会同时记录离线状态。
需要同步实际数量和网络信息时使用 `update`。重复设置完整快照不会重复发信号，
但数量或错误文字改变也算一次变化。更多规则见 [状态说明](docs/states.md)。

## 文案与图标

修改配置后调用 `setOptions`，当前提示页会立即刷新：

```cpp
auto options = host->options();
options.showImage = false;
options.showRetryButton = true;
options.errorDetail = QStringLiteral("请检查设备连接后重试");
host->setOptions(options);
```

可以给 `options.icon` 设置 QIcon。未设置图标时使用平台标准信息图标。
加载时显示忙碌进度条，不显示图标或重试按钮。Empty、Offline、Error 支持重试。
错误信息按纯文本显示；空错误信息使用配置里的默认说明。

## 自定义提示页

```cpp
auto* custom = new QWidget; // 在堆上创建，不设置父对象
// 给 custom 添加布局、文字和按钮
host->setCustomView(custom);
host->setCustomView(nullptr); // 恢复默认提示页
```

Host 接管内容控件与自定义页的所有权。替换自定义页时，旧页隐藏并延迟删除。
需要取回它时使用 `takeCustomView()`，返回控件不再有父对象，由调用方负责释放。
不要传入栈对象、Host 自身或内容控件作为自定义页。

自定义页负责自己的文案、状态展示及重试按钮连接，参见
[自定义视图与所有权](docs/custom-views.md)。默认页的配置不会自动修改自定义页。

## 线程与重试

所有 Widget 操作在 GUI 线程执行。后台线程完成请求后，用队列连接把结果交回界面。
Host 的 `stateChanged` 和 `retryRequested` 可以用于业务层联动。

组件不自动重试、不自动重连，也不清空或填充数据模型。容器通过堆叠布局切换整个内容控件，
不是覆盖列表 viewport，所以提示页显示时表头和内容一起隐藏。

## 示例和测试

`examples/widgets` 下有列表、表格和自定义页三个独立示例。
列表示例用定时器模拟重试，不连接真实设备。

Qt Test 源码覆盖状态选择、重复通知、错误消息、提示页显示、重试转发、自定义页替换及控件释放。
控制器测试不创建 Widgets；界面测试需要 QApplication 和可用的 Qt 平台插件。
具体检查步骤见 [验证清单](docs/verification.md)。

## 目录

```text
include/TBScrollViewEmpty/  公共头文件
src/                      控制器和 Widgets 实现
examples/widgets/         示例程序
tests/                    Qt Test 源码
docs/                     接入和行为说明
```
