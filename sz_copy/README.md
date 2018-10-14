#  代码规范
1，类型私有变量以及方法名称统一加"_"前缀，不需要在外部调用的属性和方法尽可能用private私有，严格限制外部访问权限。例如，对于外部只需要读不需要写的变量应当用 private(set)

2，一个controller或者视图内涉及到点击事件，统一为一个方法处理，方法名统一为：btnClick(sender: ), 方法内部使用if else 分支管理各个事件处理

3，cell高度恒定的tableView 统一使用rowHeight 来设置，避免使用代理方法设置高度

4，push，pop 操作，尽量移动到ViewModel中，尽可能不在一个controller里出现另一个controller， 同时不在一个View组件里出现另一个View组件。

5，所有的model类型都必须实现CustomDebugStringConvertible协议

6，Model命名应当与接口名路径有关联，应当做到看到Model类名就可以判断出是哪一个接口返回的数据。对于socket返回的数据Model命名统一为cmd值+Model

7, 法币价格：currencyPrice， 币币价格：coinPrice， 法币资产： currencyAsset， 币币资产：coinAsset
    币币数量：coinNum， 




