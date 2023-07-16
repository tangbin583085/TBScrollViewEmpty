# 验证清单

在已有环境中，可按 docs/building.md 构建并执行测试。以下是验证步骤，不表示已经运行通过。

- 控制器：空数据、离线、有缓存数据、负数量、错误信息和重复快照。
- 默认视图：加载动画、按钮与图标显示、纯文本错误提示和配置刷新。
- 容器：切换内容、窗口缩放、自定义页替换、还原、取回及释放。
- 示例：列表填充、清空、重试，表格展示，自定义页恢复默认。
- 安装包：在独立工程里使用 find_package 链接。
- Qt 5.15 和 Qt 6、Debug 和 Release 按项目实际支持范围检查。

GUI 测试需要平台插件。无桌面环境且已经安装 offscreen 插件时可以用：

```sh
(cd build && QT_QPA_PLATFORM=offscreen ctest -C Debug --output-on-failure)
```

这不能替代真机上的字体、缩放、主题、键盘和无障碍检查。
没有 Qt 工具链时，仅能检查源码和配置，不能称为编译或测试通过。

## English

The checklist covers state transitions, retry delivery, display rules, resizing, custom-page
ownership, examples, and installed-package use. It is a list of checks to perform, not a test report.

Run Qt Test in supported Qt versions and build configurations. An installed offscreen plugin
can support headless UI checks, but fonts, scaling, themes, keyboard behavior, and accessibility
still need a real desktop review. Source review alone is not a successful build or test run.
