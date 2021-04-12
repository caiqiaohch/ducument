把字符串当做javascript代码执行
1、setInterval("要执行的字符串",500);
window对象的方法既可以传字符串，也可以传函数。该函数第一个参数传字符串容易引起内存泄漏，尽量避免这样写。
2、setTimeOut("要执行的字符串",500);
window对象的方法既可以传字符串，也可以传函数。该函数第一个参数传字符串容易引起内存泄漏，尽量避免这样写。
3、eval("要执行的字符串");
4、new Function("要执行的字符串");
5、<script>"要执行的字符串"</script>
6、es6的import

下面主要说说Javascript的全局函数eval()和new Function()构造函数。
一、eval()
eval()可以动态解析和执行字符串，它直接把字符串当做Javascript代码执行，eval函数接收一个参数str，如果str不是字符串，则直接返回str，否则执行str语句。如果str语句执行结果是一个值，则返回此值，否则返回undefined。

JavaScript规定，如果行首是大括号，一律解释为语句（即代码块）。如果要解释为表达式（即对象），必须在大括号前加上圆括号。

eval('{foo: 123}') // 123
eval('({foo: 123})') // {foo: 123}
1、执行作用域

var a = 'global scope';
function b(){
 var a = 'local scope'
 eval('console.log(a)'); //local scope
}
b();
eval中的代码执行时的作用域为当前作用域，它可以访问到函数中的局部变量，不能访问全局变量。
如果需要，自己可以封装一个函数，让eval能访问全局。

var myNameSpace = {};
myNameSpace.Eval = function(code){ 
  if(!!(window.attachEvent && !window.opera)){ 
    //ie 
    execScript(code); 
  }else{ 
    //not ie 
    window.eval(code); 
  } 
} 
传递到eval()中的字符串：如果eval()是被直接调用的，this指的是当前对象；如果eval()是被间接调用的，this就是指全局对象。eval() 方法可以将字符串转换为JavaScript 代码并运行。

//eval()的直接调用
eval('...')

//eval()的间接调用
eval.call(null, '...')
window.eval('...')
(1, eval)('...')
(eval, eval)('...')
2、能否携带with表达式
在严格模式下，eval解析function的字符串中不允许携带with(x)表达式。
3、安全性

<script>
  var a = 1;
  eval("var a=2;");   //改变了当前域的变量a
  alert(a);
</script>
《高性能Javascript》一书指出，在代码中使用eval是很危险的，特别是用它执行第三方的JSON数据（其中可能包含恶意代码）时。应该尽可能使用JSON.parse()方法解析字符串本身，该方法可以捕捉JSON中的语法错误，并允许你传入一个函数，用来过滤或转换解析结果。
eval非常耗性能，解析成JS代码要耗能，执行时也要耗能。

二、new Function()
new Function(arg1, arg2, ..., argN, function_body);中的参数和函数体都以字符串形式传入。
new Function()可以动态解析和执行字符串，它把传入的字符串封装为anonymous匿名函数并返回，直到调用这个返回函数时，才会执行字符串所要执行的操作。编程中并不经常用到，但有时候应该是很有用的。

1、执行作用域

var a = 'global scope';
function b(){
 var a = 'local scope';
 (new Function('','console.log(a)'))(); //global scope
}
b();
new Function中的代码执行时的作用域为全局作用域，不论它在哪个地方被调用，它访问的都是全局变量a，它无法访问b函数内的局部变量。

2、能否携带with表达式
在严格模式下，new Function()的字符串中可以携带with(x)表达式，因为new Function产生的是global 作用域下的函数，默认是非严格模式。

3、安全性

<script>
  var a = 1;   
  new Function("var a=3;")();   //不改变当前作用域的变量
  alert(a);
</script>
三、总结
综上，可以发现使用new Function()运行字符串会好一些，这也就是为什么很多模板引擎采用new Function()，而没有用eval()的原因吧。