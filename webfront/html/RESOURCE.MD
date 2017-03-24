手机禁止缩放
<meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=0" />

设置Web应用是否以全屏模式运行
<meta name="apple-mobile-web-app-capable" content="yes">

禁用自动识别页面中的电话号码
<meta name="format-detection" content="telephone=no">

html5拨号
<a href="tel:4008106999,1034">400-810-6999 转 1034</a>

上下拉动滚动条时卡顿、慢
body {
    -webkit-overflow-scrolling: touch;
    overflow-scrolling: touch;
}

长时间按住页面出现闪退
element {
    -webkit-touch-callout: none;
}

设置缓存
<meta http-equiv="Cache-Control" content="no-cache" />

http://www.haorooms.com/post/phone_web
--------------------------------------------------------------------------------------
行内元素有哪些?块级元素有哪些?CSS的盒模型?
块级元素：div p h1 h2 h3 h4 form ul
行内元素: a b br i span input select
Css盒模型:内容,border ,margin,padding
--------------------------------------------------------------------------------------
<img>的title和alt有什么区别
title是当鼠标滑动到元素上的时候显示
alt是<img>的特有属性,图片无法加载时显示
--------------------------------------------------------------------------------------
data-*: 为元素增加自定义属性
--------------------------------------------------------------------------------------
<meta name="viewport" content="width=device-width,initial-scale=1,minimum-scale=1,maximum-scale=1,user-scalable=no" />
--------------------------------------------------------------------------------------