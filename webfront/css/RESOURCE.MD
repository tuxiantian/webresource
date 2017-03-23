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