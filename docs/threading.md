# 线程与异步请求

Qt Widgets 必须在 GUI 线程创建和操作。控制器虽然只依赖 Qt Core，
同一实例也只能在自己的线程调用，不提供锁。

后台读取设备后，把结果通过 Qt 队列连接传回页面。更新模型后，再用实际数据数量调用 update。
不要在后台直接修改 Host、默认页或自定义页。

重试信号不负责取消旧请求。如果用户切换设备、页面或重新加载，
建议由业务层使用请求编号或取消机制丢弃过期结果。
示例的定时器只用于演示，真实通信需要自己的超时和错误处理。

Qt 在接收对象销毁时自动移除带 context 的连接。lambda 中引用的其他对象仍需自行保证生命周期。
应用不要在状态信号回调里直接删除发送者；需要关闭页面时使用 deleteLater。

## English

Create and update Widgets on the GUI thread. Invoke each controller on its owning thread.
Send background results through queued connections, update the model, then call update.

The library does not cancel requests or reject stale responses. Use request IDs or a
cancellation mechanism when switching devices or starting a new load.

Use context-bound signal connections, manage captured object lifetimes, and prefer
deleteLater when closing a page from a state callback.
