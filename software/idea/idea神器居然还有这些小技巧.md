## 查找类和方法

如果你依稀记得某个方法名字几个字母，想在`IDEA`里面找出来，可以怎么做呢？ 
直接使用`ctrl+shift+alt+n`，使用`symbol`来查找即可。 
比如说： 
![img](https://mmbiz.qpic.cn/mmbiz_png/6fuT3emWI5JdAqiafic5QhkTd8JjOcj09jkhEoaVy2VwInQeuiadamiauBqeRF0icqt5CY22l4qCyZj57ZKtcXlJjNw/640?tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

你想找到checkUser方法。直接输入`user`即可。 
![img](https://mmbiz.qpic.cn/mmbiz_png/6fuT3emWI5JdAqiafic5QhkTd8JjOcj09jJgz90cAlVW2NHNV9CTYzsyPUONtZWia1TmXetOc1PFMFOZwhDNS8W6g/640?tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

如果你记得某个业务类里面有某个方法，那也可以使用首字母找到类,然后加个`.`，再输入方法名字也是可以的。 
![img](https://mmbiz.qpic.cn/mmbiz_png/6fuT3emWI5JdAqiafic5QhkTd8JjOcj09jmxPuib0D6FymxmiaG7NIxVvRgIYd2X0hN0btafBfMvv1howMGiaibprQ6A/640?tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

## 定位目录

使用`ctrl+shift+n`或者`ctrl+shift+r`后，使用`/`，然后输入目录名字即可. 
![img](https://mmbiz.qpic.cn/mmbiz_png/6fuT3emWI5JdAqiafic5QhkTd8JjOcj09jgwIDVLx9j11CG7abV1IFn6kZ001Us0jfUb41pfTKalGwqvM9FiaElBQ/640?tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

## 当前类在project视图里是处在哪个位置

当工程里的包和类非常多的时候，有时候我们想知道当前类在project视图里是处在哪个位置。 
![img](https://mmbiz.qpic.cn/mmbiz_png/6fuT3emWI5JdAqiafic5QhkTd8JjOcj09jTVLfWXnebJ0Z9QDA3FNyjNENPgpPwGpVafw8EkwFY1nL1XRWfSPMGg/640?tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

上面图中的`DemoIDEA`里，你如何知道它是在`spring-cloud-config`工程里的哪个位置呢？ 
可以先使用`alt+F1`，弹出`Select in`视图，然后选择`Project View`中的`Project`，回车，就可以立刻定位到类的位置了。

![img](https://mmbiz.qpic.cn/mmbiz_png/6fuT3emWI5JdAqiafic5QhkTd8JjOcj09jonwXQzTriaHPgbE2Y4Fia7rjQGpGLH3124ku3hiaeyVtzsPemcK5sxnXg/640?tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

那如何从`project`跳回代码里呢？可以直接使用`esc`退出`project`视图，或者直接使用`F4`,跳到代码里。

## Presentation Mode

我们可以使用【Presentation Mode】，将`IDEA`弄到最大，可以让你只关注一个类里面的代码，进行毫无干扰的`coding`。

可以使用`Alt+V`快捷键，弹出`View`视图，然后选择`Enter Presentation Mode`。效果如下： 
![img](https://mmbiz.qpic.cn/mmbiz_png/6fuT3emWI5JdAqiafic5QhkTd8JjOcj09jrUfnt6w6j5EBJSMHCNB8ZtiaqGAFq7BOYgk5ic4cKiaBMCNaBsCIdSx9g/640?tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

这个模式的好处就是，可以让你更加专注，因为你只能看到特定某个类的代码。可能读者会问，进入这个模式后，我想看其他类的代码怎么办？这个时候，就要考验你快捷键的熟练程度了。你可以使用`CTRL+E`弹出最近使用的文件。又或者使用`CTRL+N`和`CTRL+SHIFT+N`定位文件。

如何退出这个模式呢？很简单，使用`ALT+V`弹出view视图，然后选择`Exit Presentation Mode` 即可。但是我强烈建议你不要这么做，因为你是可以在`Enter Presentation Mode`模式下在`IDEA`里面做任何事情的。当然前提是，你对`IDEA`足够熟练。

## 编辑json字符串

如果你使用`IDEA`在编写`JSON`字符串的时候，然后要一个一个`\`去转义双引号的话，就实在太不应该了，又烦又容易出错。在`IDEA`可以使用`Inject language`帮我们自动转义双引号。 
![img](https://mmbiz.qpic.cn/mmbiz_png/6fuT3emWI5JdAqiafic5QhkTd8JjOcj09joYHpEHE1OibXSN6lfMgwY7uqU3hGHeCUGcHDTDNet7DuSp3zXSiaFzgA/640?tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

先将焦点定位到双引号里面，使用`alt+enter`快捷键弹出`inject language`视图，并选中 
`Inject language or reference`。 
![img](https://mmbiz.qpic.cn/mmbiz_png/6fuT3emWI5JdAqiafic5QhkTd8JjOcj09jH4ibMibNFdwoYls8jXgXTialYCTUgpLTKDCKesWM362PXrtuveP8nUPiaA/640?tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

选择后,切记，要直接按下`enter`回车键，才能弹出`inject language`列表。在列表中选择 `json`组件。 
![img](https://mmbiz.qpic.cn/mmbiz_png/6fuT3emWI5JdAqiafic5QhkTd8JjOcj09jOAnclLkGOXuKaAo0MOCpw97WCamwz4rPmMhxHbx9ug1iaNHwuF3uccg/640?tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

选择完后。鼠标焦点自动会定位在双引号里面，这个时候你再次使用`alt+enter`就可以看到 
![img](https://mmbiz.qpic.cn/mmbiz_png/6fuT3emWI5JdAqiafic5QhkTd8JjOcj09jicc7QGE9P8dshRJMGHkf6oRXRktcOGLv7RzaXK4b0YXP1C8v2ibnXNZQ/640?tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

选中`Edit JSON Fragment`并回车，就可以看到编辑`JSON`文件的视图了。 
![img](https://mmbiz.qpic.cn/mmbiz_png/6fuT3emWI5JdAqiafic5QhkTd8JjOcj09jialiapiaYrIjVIloxNrEAr4Sd728NON4rfAbOINgKZAFyL1P3HSiaiajjUQ/640?tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

可以看到`IDEA`确实帮我们自动转义双引号了。如果要退出编辑`JSON`信息的视图，只需要使用`ctrl+F4`快捷键即可。

`Inject language`可以支持的语言和操作多到你难以想象，读者可以自行研究。

## 某个类的名字在`project`视图里被挡住了某一部分

假设有下面的场景，某个类的名字在`project`视图里被挡住了某一部分。 
![img](https://mmbiz.qpic.cn/mmbiz_png/6fuT3emWI5JdAqiafic5QhkTd8JjOcj09juVib0uVeSWmyMawpRMGb8KQviasA1HLOnCwOtq2iava9SqQKm0f0ZicJHQ/640?tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

你想完整的看到类的名字，该怎么做。一般都是使用鼠标来移动分割线，但是这样子效率太低了。可以使用`alt+1`把鼠标焦点定位到`project`视图里，然后直接使用`ctrl+shift+左右箭头`来移动分割线。

## 自动生成not null这种if判断 

![img](https://mmbiz.qpic.cn/mmbiz_png/6fuT3emWI5JdAqiafic5QhkTd8JjOcj09joHL8YW58FzqF5mx9XMhMrLua30H7a49rQBpKUA3QSDRa391icsib19bw/640?tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

当我们使用rabbitTemplate. 后，直接输入`notnull`并回车，`IDEA`就好自动生成if判断了。 
![img](https://mmbiz.qpic.cn/mmbiz_png/6fuT3emWI5JdAqiafic5QhkTd8JjOcj09jH9TspAkG2BNdhKNzoM3fUNlDRwOe423Y3oEhE1PUz3UzY3lcVRdMLQ/640?tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

## 找到所有的try catch语句,但是catch语句里面没有做异常处理的

根据模板来找到与模板匹配的代码块。比如说：

>  想在整个工程里面找到所有的try catch语句,但是catch语句里面没有做异常处理的。

catch语句里没有处理异常，是极其危险的。我们可以`IDEA`里面方便找到所有这样的代码。 
![img](https://mmbiz.qpic.cn/mmbiz_png/6fuT3emWI5JdAqiafic5QhkTd8JjOcj09jBDwRHDPZrXj2qibwMvML2nfGGJRuOflk5M6HiaLcnTib9ga69S3HoDvdA/640?tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

首先使用`ctrl+shift+A`快捷键弹出action框，然后输入`Search Struct` 
![img](https://mmbiz.qpic.cn/mmbiz_png/6fuT3emWI5JdAqiafic5QhkTd8JjOcj09jppmiclic3FibGt5Q82qo3WjJHy8kUSYBLj3WgXbV3mWYydlv6sCQRnF2A/640?tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

选择`Search Structurally`后，回车，跳转到模板视图。 
![img](https://mmbiz.qpic.cn/mmbiz_png/6fuT3emWI5JdAqiafic5QhkTd8JjOcj09jib7V0DRJmIUeUCXKicqr6Nhxjf1MpVRFdtomFKOtjFxhABEUk0blZLJg/640?tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

点击`Existing Templates`按钮，选择`try`模板。为了能找出catch里面没有处理异常的代码块，我们需要配置一下`CatchStatement`的`Maximum count`的值，将其设置为1。

点击`Edit Variables`按钮，在界面修改`Maximum count`的值。 
![img](https://mmbiz.qpic.cn/mmbiz_png/6fuT3emWI5JdAqiafic5QhkTd8JjOcj09jiarPfRvDTpgTbtKXw74tNuyVpmVkmoJcAWTILPoqv0zca82E14JdA2Q/640?tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

最后点击`find`按钮，就可以找出catch里面没有处理异常的代码了。 
![img](https://mmbiz.qpic.cn/mmbiz_png/6fuT3emWI5JdAqiafic5QhkTd8JjOcj09jwdRFYCedfZhkDLe4dbibf1olWJdHDlkPhx5ICRBzgYsqhZMjblnKwLg/640?tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

## 去掉导航栏，因为平时用的不多

![img](https://mmbiz.qpic.cn/mmbiz_png/6fuT3emWI5JdAqiafic5QhkTd8JjOcj09jF79uNFKCFyprdHvXnORKQicpic0XM6eucG7Sr57KffUp7LGfib62kNic8g/640?tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

可以把红色的导航栏去掉，让`IDEA`显得更加干净整洁一些。使用`alt+v`，然后去掉`Navigation bar`即可。去掉这个导航栏后，如果你偶尔还是要用的，直接用`alt+home`就可以临时把导航栏显示出来。 
![img](https://mmbiz.qpic.cn/mmbiz_png/6fuT3emWI5JdAqiafic5QhkTd8JjOcj09jCMgSicyzLBSmVorTIheiblep85xsMdmYYCSQ3ibpEBllEsT51k8M3MaYw/640?tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

如果想让这个临时的导航栏消失的话，直接使用`esc`快捷键即可。

## 假设有下面的场景，某个类的名字在`project`视图里被挡住了某一部分。 

![img](https://mmbiz.qpic.cn/mmbiz_png/6fuT3emWI5JdAqiafic5QhkTd8JjOcj09juVib0uVeSWmyMawpRMGb8KQviasA1HLOnCwOtq2iava9SqQKm0f0ZicJHQ/640?tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

你想完整的看到类的名字，该怎么做。一般都是使用鼠标来移动分割线，但是这样子效率太低了。可以使用`alt+1`把鼠标焦点定位到`project`视图里，然后直接使用`ctrl+shift+左右箭头`来移动分割线。