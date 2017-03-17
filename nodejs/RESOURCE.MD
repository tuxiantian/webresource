### gulp 自动添加版本号
> http://www.tuicool.com/articles/UbaqyyJ  
根据静态资源内容，生成md5签名，打包出来的文件名会加上md5签名，同时生成一个json用来保存文件名路径对应关系。
替换html里静态资源的路径为带有md5值的文件路径，这样html才能找到资源路径。比较重要的一点：静态服务器需要配置静态资源的过期时间为永不过期。

#### 达到什么效果:
> 1. 静态资源只需请求一次，永久缓存，不会发送协商请求304  
> 2. 版本更新只会更新修改的静态资源内容  
> 3. 不删除旧版本的静态资源，版本回滚的时候只需要更新html，同样不会增加http请求次数

### vscode官网使用文档
> http://code.visualstudio.com/docs/editor/debugging#_launch-configurations