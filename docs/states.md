# 状态规则

初始快照是 Content、0 条数据、Unknown 网络状态。构造 Host 不会推断模型是否为空；
完成页面初始化后显式调用 update。

update 的选择顺序是：有数据先显示 Content，没有数据且离线显示 Offline，否则显示 Empty。
负数量或非法 NetworkStatus 会抛出 std::invalid_argument，并保持当前快照不变。
不要把异常穿过 Qt 事件循环；业务输入先验证，必要时在调用处捕获。

setLoading/setEmpty/setContent 保留数量与网络信息，并清空旧错误。
setOffline 同时把网络值改为 Offline。setError 保留数量、网络并记录消息。
手动切换只是展示指令，不代表模型内容或网络已经变化。

快照包括状态、数量、网络和错误文字。四项都相同才会抑制重复通知。
stateChanged 按值发送快照，可用于队列连接；控制器只在所属线程调用。
requestRetry 仅发通知，不改变状态。业务层决定是否进入 Loading。

## English

The initial snapshot is Content with zero items and Unknown network status.
Call update after initializing your model.

Positive counts show Content even offline. With zero items, Offline selects the offline
page; other network states select Empty. Invalid inputs throw without mutating state.

Manual setters keep metadata, clear stale error text, and select a display state.
setOffline also records an offline network value. setError stores the supplied message.

Equality covers all snapshot fields. Retry is only a notification. Queued state signals
carry a value copy; invoke controller methods on its owning thread.
