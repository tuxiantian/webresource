## 编辑器与窗口管理

同时打开多个窗口（查看多个项目）

打开一个新窗口： Ctrl+Shift+N  
关闭窗口： Ctrl+Shift+W  
查看-切换编辑器组布局 控制横向拆分窗口还是纵向拆分窗口  
Ctrl+` 切换终端面板  
Alt+Shift+V 预览markdown文档  
## Ctrl+P 模式

在Ctrl+P下输入>又可以回到主命令框 Ctrl+Shift+P模式。

在Ctrl+P窗口下还可以

直接输入文件名，快速打开文件
* ? 列出当前可执行的动作
* ! 显示Errors或Warnings，也可以Ctrl+Shift+M
* : 跳转到行数，也可以Ctrl+G直接进入
* @ 跳转到symbol（搜索变量或者函数），也可以Ctrl+Shift+O直接进入
* @:根据分类跳转symbol，查找属性或函数，也可以Ctrl+Shift+O后输入:进入
* \# 根据名字查找symbol，也可以Ctrl+T
## 光标相关
移动到文件结尾：Ctrl+End  
移动到文件开头：Ctrl+Home  
选中当前行Ctrl+i（双击）  

Alt+Shift+鼠标左键 进入列编辑模式，同时编辑多列  
Multi-Cursor：可以连续选择多处，然后一起修改，Alt+Click添加cursor  
上下移动一行： Alt+Up 或 Alt+Down

删除光标右侧的所有字Ctrl+Delete  
删除光标所在行 Ctrl+Shift+K  

整个文件夹中查找 Ctrl+Shift+F  

## 显示相关

全屏：F11  
zoomIn/zoomOut：Ctrl + =/Ctrl + -  
侧边栏显/隐：Ctrl+B  
预览markdown Ctrl+Shift+V  

## 其他

自动保存：File -> AutoSave ，或者Ctrl+Shift+P，输入 auto

## 常用的vscode插件
* Markdown Paste Image  
    命令窗口：Markdown Paste Image，会自动保存图片，且可以指定保存路径，Ctrl+V粘贴插入图片语句到markdown文件
* Markdown PasteURL  
    命令窗口：PasteURL,以优雅的方式快速插入链接  
* Markdown Shortcuts  
    markdown语法快捷键，右键可以使用  
* Markdown Theme Kit  
    给代码加上好看的颜色  
* Markdown TOC  
    生成markdown的目录  
    markdown Toc:Insert/Update  
* markdown-index  
    给标题添加序号  
    markdown add index  
* Table Formatter  
    pretty Markdown文件中的表格  
    Table: format current  
    Table: format all  
* vscode-pandoc  
    markdown文件生成PDF、Word、HTML文件

## 颜色主题
推荐编辑时使用Dark+(default dark)  
阅读时使用Markdown Editor  
设置方式是文件-首选项-颜色主题
### 使用GitHub样式预览markdown文档
```
cd C:\Users\tuxt\.vscode\extensions
git clone git@github.com:mjbvz/vscode-github-markdown-preview-style.git
cd vscode-github-markdown-preview-style
npm install
```