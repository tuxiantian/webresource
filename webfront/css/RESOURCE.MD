强制换行 word-break: break-all;
强制不换行 word-break: keep-all;
--------------------------------------------------------------------------------------
清除图片下方出现几像素的空白间隙
img{display:block;}
#test{font-size:0;line-height:0;}
#test为img的父元素
--------------------------------------------------------------------------------------
让单行文本在容器内垂直居中
#test{height:25px;line-height:25px;}
--------------------------------------------------------------------------------------
清除浮动
#test{zoom:1;}
#test:after{display:block;clear:both;visibility:hidden;height:0;content:'';}
#test为浮动元素的父元素
--------------------------------------------------------------------------------------
移除img边框
a img{ border:none; }

css手型点击样式

input[type=submit],label,select,.pointer { cursor:pointer; }

移动超链接的虚线框
a:active, a:focus{ outline:none; }
--------------------------------------------------------------------------------------
table边框合并，显示单线框
table{
   border-collapse: collapse;
}
table tr td,table tr th{
   border:1px solid #e2e2e2;
}
--------------------------------------------------------------------------------------
移除input类型为number在谷歌浏览器下自带的上下箭头
input::-webkit-outer-spin-button,
input::-webkit-inner-spin-button {
    -webkit-appearance: none !important;
    margin: 0;
}
--------------------------------------------------------------------------------------
解决position:fixed抖动的问题
<div style="position:fiexd;bottom:0px;">
  <div style="position:absolute;">
</div>
</div>
--------------------------------------------------------------------------------------
vh、vw、vmin、vmax这四个单位都是基于视口的
vw是相对视口（viewport）的宽度而定的，长度等于视口宽度的1/100著作权归作者所有。
vh是相对视口（viewport）的高度而定的，长度等于视口高度的1/100著作权归作者所有。
vmin和vmax是相对于视口的高度和宽度两者之间的最小值或最大值著作权归作者所有。

rem是相对于根元素（html）的字体大小（font-size）来计算的长度单位著作权归作者所有。
em是相对于其父元素的字体大小 当元素自身设置了字体大小，那么如果它的其他css属性也使用em单位，则会基于它自身的字体大小著作权归作者所有。
--------------------------------------------------------------------------------------