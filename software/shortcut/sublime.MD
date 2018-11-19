### sublime配置

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

## shortcut

shift+alt+1:取消分屏
shift+alt+2：分屏
ctrl+K,ctrl+B:显示或隐藏侧边栏
ctrl+P:搜索并打开文件
ctrl+N:新建文件
ctrl+W:关闭当前选项卡
Windows下鼠标右键＋shift或ctrl+shift+L:列编辑模式
ctrl+J:多行转为一行
ctrl+shift+d 快速复制当前行代码并插入到下一行
ctrl+shift+up/down：交换两行顺序

### sublime插件

#### DeleteBlankLines
1. 通过ctrl+shift+p组合键打开命令面板 
2. 输入install packge后回车
3. 输入DeleteBlankLines后回车进行安装
4. 选中要删除空白行的文本范围，一般是ctrl+A直接全选 
5. 通过ctrl+alt+backspace执行一键去除空白行功能
### sublimeTmpl插件
* 使用Ctrl + Alt +H快捷键生成html文件
* 使用Ctrl + Alt +J快捷键生成javascript文件
* 使用Ctrl + Alt +C快捷键生成css文件
* 使用Ctrl + Alt +P快捷键生成php文件
* 使用Ctrl + Alt +R快捷键生成ruby文件
* 使用Ctrl + Alt +Shift+P快捷键生成pyhton文件

## personalized setting

黑色背景下让选中的文字颜色突出显示
Perferences->Color Scheme->Monokai Bright