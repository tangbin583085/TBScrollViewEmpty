# 自定义视图和所有权

Host 接管 content，Qt 布局会把它设为 Host 的子控件。
传入堆上创建的对象，不能传入栈对象或 Host 的祖先控件。

自定义提示页通过 setCustomView 传入，要求无父对象，且不能是 content 或 Host。
它对所有非 Content 状态可见；如果需要不同文案或动画，自行连接 Host 的 stateChanged。
自定义按钮可连接 controller()->requestRetry。

替换自定义页时旧页会隐藏，解除与 Host/控制器之间的接收连接，并 deleteLater。
事件循环尚未处理延迟删除前，旧页可能仍存在。
takeCustomView 返回无父对象且隐藏的控件，不删除它；调用方负责重用或释放。
取回后需要重新连接按钮与业务逻辑。
已经投递到事件队列的调用可能仍会执行；涉及异步请求时，业务层仍需校验请求是否过期。

Host 析构时释放仍归它所有的控件。通常不要在外部手动删除被托管的控件；
代码对自定义页或内容被外部删除提供了回退处理，但这不是推荐用法。
内容被删除时 Host 会展示空页，控制器快照仍代表最后一次业务状态。

## English

The host owns its content and active custom page. Use heap widgets.
Custom pages must have no parent and cannot be the host or content.

A custom page is shown for every non-content state. Connect stateChanged if it needs
its own state-specific text. Connect its retry button to controller()->requestRetry.

Replacement hides the old page, disconnects host/controller receivers, and schedules deletion.
takeCustomView instead releases a hidden, unparented widget to the caller. Reconnect it
when reusing it and delete it when no longer needed.
Already queued calls may still be delivered after disconnection; guard stale requests in the application.

Host destruction deletes widgets still owned by it. Avoid externally deleting them.
A defensive fallback exists if that happens; loss of content does not alter the controller's snapshot.
