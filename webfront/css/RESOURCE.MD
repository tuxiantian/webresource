强制换行 word-break: break-all;
强制不换行 word-break: keep-all;
---
清除图片下方出现几像素的空白间隙
img{display:block;}
#test{font-size:0;line-height:0;}
#test为img的父元素
---
让单行文本在容器内垂直居中
#test{height:25px;line-height:25px;}
---
清除浮动
#test{zoom:1;}
#test:after{display:block;clear:both;visibility:hidden;height:0;content:'';}
#test为浮动元素的父元素
---
