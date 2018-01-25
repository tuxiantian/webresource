## 文档中出现这些向下的箭头怎么处理
Hi, 我们会用下箭头显示Markdown中的 显示换行 （两个空格 加 shift+回车），以区别源码中的hard line break

[可以通过自定义CSS隐藏](http://support.typora.io/Add-Custom-CSS/)

```css
 [md-inline="linebreak"]::after {
    opacity:0 !important; 
}
```