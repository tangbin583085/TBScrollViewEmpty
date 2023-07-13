# qmake 接入

现有 qmake 工程可以直接编译源码。假设仓库位于 third_party/TBScrollViewEmpty：

```qmake
QT += core gui widgets
CONFIG += c++17
TBEMPTY_ROOT = $$PWD/third_party/TBScrollViewEmpty
INCLUDEPATH += $$TBEMPTY_ROOT/include
HEADERS += $$files($$TBEMPTY_ROOT/include/TBScrollViewEmpty/*.hpp)
SOURCES += $$TBEMPTY_ROOT/src/EmptyStateController.cpp \
           $$TBEMPTY_ROOT/src/EmptyStateView.cpp \
           $$TBEMPTY_ROOT/src/EmptyStateHost.cpp
win32-msvc*: QMAKE_CXXFLAGS += /utf-8
```

HEADERS 列表必须包含有 Q_OBJECT 的头文件，让 qmake 生成 moc 代码。
修改 .pro 后重新运行 qmake。需要 C++ 异常支持，不能禁用异常后继续使用这个接口。

不要同时把同一份源码编译进应用又链接已构建的静态库，否则可能重复定义。

## English

Add the three source files and public headers as shown above. Keep Q_OBJECT headers
in HEADERS so qmake runs moc. Enable C++17 and exception support. MSVC source encoding
must support the default UTF-8 text.

Compile sources directly or link the CMake-built library; do not do both.
