javascript es6
1、字符串的扩展
主要增加对大于0xFFFF的码点的支持

for...of循环遍历
var text = String.fromCodePoint(0x20BB7);
for (let i of text) {
  //可以识别大于0xFFFF的码点
  console.log(i); //吉
}

模板字符串
let name = 'Yoda'
console.log('My name is ' + name) //
console.log(`My name is ${name}`) //模板字符串
模板字符串（template string）是增强版的字符串，用反引号（`）标识。
它可以当作普通字符串使用，也可以用来定义多行字符串，或者在字符串中嵌入变量

2、数值的扩展
ES6提供了二进制和八进制数值的新的写法，分别用前缀0b（或0B）和0o（或0O）表示。
0b111110111 === 503 // true
0o767 === 503 // true

number新增方法：

Number.isFinite():检查一个数值是否非无穷（infinity）。
Number.isNaN():检查一个值是否为NaN
Number.parseInt()
Number.parseFloat()ES6将全局方法parseInt()和parseFloat()，移植到Number对象上面
Number.isInteger() 判断一个值是否为整数
Number.EPSILON :极小的常量Number.EPSILON,的实质是一个可以接受的误差范围。
安全整数和Number.isSafeInteger() JavaScript能够准确表示的整数范围在-2^53到2^53之间（不含两个端点），超过这个范围，无法精确表示这个值。
Number.MAX_SAFE_INTEGER和Number.MIN_SAFE_INTEGER这两个常量，用来表示这个范围的上下限。

math新增方法
Math.trunc()：用于去除一个数的小数部分，返回整数部分
Math.sign(): 用来判断一个数到底是正数、负数、还是零。
Math.cbrt方法用于计算一个数的立方根。
Math.clz32方法返回一个数的32位无符号整数形式有多少个前导0。
Math.imul方法返回两个数以32位带符号整数形式相乘的结果，返回的也是一个32位的带符号整数。
Math.fround方法返回一个数的单精度浮点数形式。
Math.hypot方法返回所有参数的平方和的平方根

3、数组的扩展
Array.from方法用于将两类对象转为真正的数组
常见的类似数组的对象是DOM操作返回的NodeList集合，以及函数内部的arguments对象
let ps = document.querySelectorAll('p');
Array.from(ps).forEach(function (p) {
  console.log(p);
});

Array.of()
Array.of方法用于将一组值，转换为数组
Array(3) // [, , ,]  参数个数只有一个时，实际上是指定数组的长度。
Array(3, 11, 8) // [3, 11, 8]


数组的解构赋值
let [foo, [[bar], baz]] = [1, [[2], 3]];
let [head, ...tail] = [1, 2, 3, 4]; tail=[2,3,4]
let [x, y, z] = new Set(["a", "b", "c"])

const [a, b, c, d, e] = 'hello';

var map = new Map();
map.set('first', 'hello');
map.set('second', 'world');

for (let [key, value] of map) {
  console.log(key + " is " + value);
}

提取JSON数据
var jsonData = {
  id: 42,
  status: "OK",
  data: [867, 5309]
}
let { id, status, data: number } = jsonData;
console.log(id, status, number)

从函数返回多个值
function example() {
  return [1, 2, 3];
}
var [a, b, c] = example();

交换变量的值
[x, y] = [y, x];

let的块作用域
function cat(){
    let mew = '喵'
    let angry = true
    console.log(mew)
    if(angry){
        let mew = '...'  //外层{}成为块作用域
        console.log(mew)
    }
    console.log(mew)
}
cat()
//喵
//...
//喵

使用let声明只在块级作用域内有效
var a = []
for (let i = 0; i < 5; i++) {
  a[i] = function () {
    console.log(i)
  }
}
a[3]()

--------------------------------------------------------------------------------------

function sleep(time) {
  return function() {
    return new Promise((resolve) => setTimeout(resolve, time));
  };
}

sleep(1000)().then(function() {
  console.log('1000ms后运行');
}).then(sleep(3000)).then(function() {
  console.log('3000ms后运行');
});

es6 generator 函数的执行可以被控制
// 数组
function* GenFunc() {
  yield [1, 2];
  yield* [3, 4];
  yield "56";
  yield* "78";
}
var gen = GenFunc();
console.log(gen.next().value); // [1, 2]
console.log(gen.next().value); // 3
console.log(gen.next().value); // 4

// generator函数
function* Gen1() {
  yield 2;
  yield 3;
}
function* Gen2() {
  yield 1;
  yield* Gen1();
  yield 4;
}
var g2 = Gen2();
console.log(g2.next().value); // 1
console.log(g2.next().value); // 2
console.log(g2.next().value); // 3
console.log(g2.next().value); // 4
yield*会逐个调用右侧可迭代对象的next方法

--------------------------------------------------------------------------------------
//可遍历对象
let arr = ['a', 'b', 'c'];
let arrIterator = `arr[Symbol.iterator]()`

let set = new Set([1,2,3]);
let setIterator = `set[Symbol.iterator]()`

let map = new Map([x,1][y,2]);
let mapIterator = `map[Symbol.iterator]()`
--------------------------------------------------------------------------------------
用let替换var来定义变量. 如果是常量，使用const
静态字符串统一用单引号'' , 动态拼接成的字符串统一用反引号``
往对象里添加/修改属性时，使用Object.assign，而不用松散的.语法
const objectA = {};
Object.assign(objectA, { attr1: 3 });
--------------------------------------------------------------------------------------
// 字面量方式定义的对象默认是可扩展的.
var o2 = {};
console.log(Object.isExtensible(o2) === true); // true

//...但可以改变
Object.preventExtensions(o2);
console.log(Object.isExtensible(o2) === false); // true

让一个对象变的不可扩展 不可扩展的对象的属性通常仍然可以被删除

Object.freeze() 方法可以冻结一个对象，冻结指的是这个对象永远不可变。数据属性的值不可更改，包括getter,setter
Object.freeze(o);
console.log(Object.isFrozen(o) === true); // true
--------------------------------------------------------------------------------------
es6
new.target元属性
函数内部有两个方法 [[call]] 和 [[construct]] (箭头函数没有这个方法)，当使用new 操作符时，
函数内部调用 [[construct]]， 创建一个新实例，this指向这个实例； 不使用new 操作符时， 函数内部调用 [[call]]
ES6 通过new.target 来判断是否使用new
if (typeof new.target !== "undefined")
--------------------------------------------------------------------------------------
ES6 引入了块级作用域，明确允许在块级作用域之中声明函数
函数声明语句的行为类似于let，在块级作用域之外不可引用
// ES6严格模式
'use strict';
if (true) {
  function f() {}
}
--------------------------------------------------------------------------------------