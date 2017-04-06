### 搭建环境需要安装的软件
- [ ] MSCODE  
- [ ] mysql  
- [ ] mysql客户端  
- [ ] jdk  
- [ ] git  
- [ ] maven  
- [ ] tomcat  
- [ ] everything  
- [ ] foxmail  
- [ ] jdgui  
- [ ] jsonview  
- [ ] 有道云笔记、有道词典  
- [ ] pdf阅读器
- [ ] qq、微信  
- [ ] 文档资料  
- [ ] eclipse  
- [ ] 谷歌浏览器  
### 环境搭建流程
1. 下载软件:MSCODE、有道云笔记、有道词典、qq、微信、谷歌浏览器、foxmail、git、maven
2. 安装现有软件：mysql、mysql客户端、tomcat、eclipse、jdk、everything、jdgui、jsonview
3. 拷贝文档：梳理的技术参考资料
4. 个性化配置 ：账户设置等
### idea个性化设置
#### 设置idea的快捷键为eclipse的快捷键
file-settings-keymap-eclipse
#### 更改IntelliJ的快捷键为Eclipse风格，并且恢复Alt+/代码自动补全快捷键code completion
> http://blog.csdn.net/shijiebei2009/article/details/44725733
####  IntelliJ中的main函数和System.out.println()快捷键
> http://blog.csdn.net/shijiebei2009/article/details/44726433

#### sublime text 添加到鼠标右键功能
把以下内容复制并保存到文件，重命名为：sublime_addright.reg，然后双击就可以了。  
```
Windows Registry Editor Version 5.00
[HKEY_CLASSES_ROOT\*\shell\SublimeText3]
@="use SublimeText3 open"
"Icon"="C:\\Program Files (x86)\\Sublime Text3\\sublime_text.exe,0"
[HKEY_CLASSES_ROOT\*\shell\SublimeText3\command]
@="C:\\Program Files (x86)\\Sublime Text3\\sublime_text.exe %1"
[HKEY_CLASSES_ROOT\Directory\shell\SublimeText3]
@="use SublimeText3 open"
"Icon"="C:\\Program Files (x86)\\Sublime Text3\\sublime_text.exe,0"
[HKEY_CLASSES_ROOT\Directory\shell\SublimeText3\command]
@="C:\\Program Files (x86)\\Sublime Text3\\sublime_text.exe %1"
```
**注意：需要把下面代码中的Sublime的安装目录（标粗部分），替换成自已实际的Sublime安装目录**

#### eclispe代码自动提示
Window ——> Preferences ——> Java ——> Editor ——> Content Assist  
[auto activation triggers for java]自动补全触发器,默认是".", 这个位置可以设置成  
“.abcdefghijklmnopqrstuvwxyz(,”  