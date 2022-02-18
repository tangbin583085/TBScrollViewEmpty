# 构建与安装

准备好 Qt、C++17 编译器和 CMake 后，在仓库根目录执行：

```sh
cmake -S . -B build -DCMAKE_PREFIX_PATH=/path/to/Qt -DTBEMPTY_BUILD_EXAMPLES=ON -DTBEMPTY_BUILD_TESTS=ON
cmake --build build --config Debug
(cd build && ctest -C Debug --output-on-failure)
```

测试需要 Qt Test 模块。默认关闭示例和测试，不使用外部测试框架。

三个示例目标是 `tbempty_list`、`tbempty_table` 和 `tbempty_custom`。
可执行文件在构建目录的 `examples/widgets` 下；多配置生成器还会有 Debug/Release 子目录。

## 安装后使用

```sh
cmake -S . -B build-install -DCMAKE_PREFIX_PATH=/path/to/Qt -DCMAKE_INSTALL_PREFIX=./install
cmake --build build-install --config Release
cmake --install build-install --config Release
```

在使用方的 CMake 中：

```cmake
find_package(TBScrollViewEmpty 1 CONFIG REQUIRED)
target_link_libraries(MyApp PRIVATE TBScrollViewEmpty::Widgets)
```

将安装目录和 Qt 目录加入使用方的 CMAKE_PREFIX_PATH。
安装包需要与构建时相同的 Qt 主版本及兼容的编译器/ABI。
Windows 上库和使用方应使用匹配的 MSVC 或 MinGW 工具链。
库使用静态链接目标，不需要自行处理 DLL 导出宏；Qt 的部署由应用负责。
