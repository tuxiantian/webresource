在IE9+和firefox中,开始支持event.isTrusted属性,如果是用户发生的,就是true,否则就是false,并且这个属性不能被修改
```
if(e.hasOwnProperty('originalEvent'))

if(e.hasOwnProperty('originalEvent')){
  console.log('--Probably a real click.');
 }else{
  console.log('-- Probably a fake click.');
}

if(e.which) {
  console.log('--Actually clicked--');
}else {
  console.log('---Triggered by code-')
}
```
http://stackoverflow.com/questions/6674669/in-jquery-how-can-i-tell-between-a-programmatic-and-user-click
--------------------------------------------------------------------------------------
```
var json = '{"name":"GDT","age":23,"University":"GDUT"}';
var info = eval('(' + json + ')');  //解析为JSON对象
```
--------------------------------------------------------------------------------------
数组去重(相同类型)
```
Array.prototype.unique3=function(){
    var res=[]; //创建一个存放数组结果集
    var json={};//对象属性标识数组中是否有重复元素
    for(var i = 0, len = this.length; i < len; i++){
        if (!json[this[i]]) {
            res.push(this[i]);
            json[this[i]]=1;
        }
    }
    return res;
}
var array3=['d','c','d','a','v','n','v'];
console.info(array3.unique3());
```
--------------------------------------------------------------------------------------
获取数组最值
```
var numbers = [5, 458 , 120 , -215 , 228 , 400 , 122205, -85411];
var maxInNumbers = Math.max.apply(Math, numbers);
var minInNumbers = Math.min.apply(Math, numbers);
```
--------------------------------------------------------------------------------------
乱序
```
var numbers = [5, 458 , 120 , -215 , 228 , 400 , 122205, -85411];
numbers = numbers.sort(function(){ return Math.random() - 0.5});
```
--------------------------------------------------------------------------------------
清空数组的三种方式
```
var array = [1, 2, 3, 4];
//方式1
array.splice(0,array.length); //删除数组中所有项
//方式2
array.length = 0;  //length属性可以赋值,length是只读
//方式3
array = [];  // 推荐

for (var name in object) {
    if (object.hasOwnProperty(name)) {
        // do something with name
    }
}
```
--------------------------------------------------------------------------------------
```
var array = [6,7,5,84,6];
//所有对象,都具有toString和valueOf
console.log(array.toString());//toSTring内部就调用join()
console.log(array.valueOf());//返回当前数组对象
```
--------------------------------------------------------------------------------------
```
"37"-7  -->30
"37"+7  -->377
0+"1"   -->01
"1"+"1" -->"11"
(+"1")+(+"1") -->2
+"1"+ +"1"  -->2

+null -->0
1+null-->1
!null true

Undefined用作数字时类型表现为NaN, 用作布尔时表现为false.
var a;
typeof(a) -->
"undefined"
1+a -->NaN
typeof(1+a) -->number
typeof+""  -->number"
```
--------------------------------------------------------------------------------------
Number函数 Number函数将字符串转为数值
数值：转换后还是原来的值
字符串：如果可以被解析为数值,则转换为相应的数值,否则得到NaN空字符串转为0
布尔值：true转成1,false转成0
undefined：转成NaN
null：转成0

parseInt逐个解析字符,而Number函数整体转换字符串的类型
parseInt('42 cats') // 42
Number('42 cats') // NaN

Number('\t\v\r12.34\n') // 12.34

对象的转换规则
先调用对象自身的valueOf方法  -->原始类型?
再调用对象自身的toString方法 -->原始类型?
报错
Number({a:1})// NaN

undefined  --> NaN
null       --> 0
true       --> 1
false      --> 0
--------------------------------------------------------------------------------------
String函数
数值：转为相应的字符串
字符串：转换后还是原来的值
布尔值：true转为“true”，false转为“false”
undefined：转为“undefined”
null：转为“null”

String(true) // "true"
String(undefined) // "undefined"
String(null) // "null"

先调用toString方法 -->原始类型?
调用valueOf方法    -->原始类型?
报错
String({a:1}) // "[object Object]"

[1,2,3].toString() // --> "1,2,3"
1+1+"2"  -->22
1+"2"  -->12
--------------------------------------------------------------------------------------
Boolean函数：强制转换成布尔值
转为false
undefined
null
-0
+0
NaN
''(空字符串)

所有对象的布尔值都是true
Boolean(new Boolean(false)) -->true
Boolean([]) // true
Boolean({}) // true
--------------------------------------------------------------------------------------
字符串的自动转换
主要发生在加法,当一个值为字符串，另一个值为非字符串，则后者转为字符串
```
'5' + false // "5false"
'5' + {} // "5[object Object]"
'5' + [] // "5"
'5' + function (){} // "5function (){}"
'5' + undefined // "5undefined"
'5' + null // "5null"
```
--------------------------------------------------------------------------------------
加法运算符+是双目运算符，只要其中一个是String类型，表达式的值便是一个String
对于其他的四则运算，只有其中一个是Number类型，表达式的值便是一个Number
对于非法字符的情况通常会返回NaN
```
'5' - '2' // 3
'5' * '2' // 10
true - 1  // 0
false - 1 // -1
'1' - 1   // 0
'5'*[]    // 0
false/'5' // 0
'abc'-1   // NaN
+'abc' // NaN
-'abc' // NaN
+true // 1
-false // 0
```
--------------------------------------------------------------------------------------
```
1 + [1,2] --> "11,2"
1 + {a:1} -->"1[object Object]"
{a:1} + 1  -->1  --> {a:1};+1
({a:1})+1  -->"[object Object]1"
```
--------------------------------------------------------------------------------------
空数组 + 空数组
[]+[] -->""

空数组 + 空对象
[] + {}  -->"[object Object]"  ""+{}

空对象 + 空数组
{} + []   -->0 {]视为代码块
({}) + []  -->"[object Object]"

空对象 + 空对象
{} + {} -->  "[object Object][object Object]"
--------------------------------------------------------------------------------------
两次非操作将会返回等同于变量转换成布尔值
!!a
--------------------------------------------------------------------------------------
随机字符串 [0-9a-z]（36个),截掉起始的"0."
Math.random().toString(36).substr(2);
--------------------------------------------------------------------------------------
```
function trim(str) {
    if(str == null || typeof str == "undefined"){
        return "";
    }
    return str.replace(/(^\s*)|(\s*$)/g, "");
};
$.trim(str)
```
---
```
data = data.replace(/\+/g, "%2B");
data = data.replace(/\&/g, "%26");
```
---
数组追加
```
var array1 = [12 , "foo" , {"name": "Joe"} , -2458];
var array2 = ["Doe" , 555 , 100];
Array.prototype.push.apply(array1, array2);
```
array2 追加到array1
--------------------------------------------------------------------------------------
不缓存
```
<META HTTP-EQUIV="pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Cache-Control" CONTENT="no-cache, must-revalidate">
<META HTTP-EQUIV="expires" CONTENT="0">

$.ajax({
     url:'www.haorooms.com',
     dataType:'json',
     data:{},
     cache:false,
     ifModified :true ,
     async:false,
     success:function(response){
         //操作
     }
  });

beforeSend :function(xmlHttp){
        xmlHttp.setRequestHeader("If-Modified-Since","0");
        xmlHttp.setRequestHeader("Cache-Control","no-cache");
},

在 URL 参数后加上 "?timestamp=" + new Date().getTime();
```
--------------------------------------------------------------------------------------