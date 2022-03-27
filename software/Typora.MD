## 文档中出现这些向下的箭头怎么处理
Hi, 我们会用下箭头显示Markdown中的 显示换行 （两个空格 加 shift+回车），以区别源码中的hard line break

[可以通过自定义CSS隐藏](http://support.typora.io/Add-Custom-CSS/)

```css
 [md-inline="linebreak"]::after {
    opacity:0 !important; 
}
```
## 文件列表视图下，选中激活的item颜色比较浅，怎么办？
自定义样式如下
```
.file-list-item.active {
background:#7E7E7E;
color: black
}
```
## 如何找到自定义样式文件的位置
文件-偏好设置-高级设置-打开高级设置-找到themes目录-打开base.user.css  
我的主题目录如下  
> C:\Users\tuxiantian\AppData\Roaming\Typora\themes