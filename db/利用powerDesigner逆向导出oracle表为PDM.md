---
typora-root-url: ..
---

[利用powerDesigner逆向导出oracle表为PDM](<https://blog.csdn.net/shehun11/article/details/45038501>)

创建数据源时遇到的问题

![ABCFD281-BD81-4b15-9149-81F7915A9D92](/images/db/ABCFD281-BD81-4b15-9149-81F7915A9D92.png)

这是因为我没有安装oracle的客户端

我用的是精简版的客户端，就是官方下载的instantclient-basic-windows.x64-12.2.0.1.0.zip

安装oracle的客户端后（安装之前先删除之前配置的精简版客户端的环境变量），这个问题就解决了。