# typescript

https://www.runoob.com/typescript/ts-operators.html

## 变量
const getValue = () => {
  return 0
}

var [变量名] : [类型] = 值;

函数返回值
有时，我们会希望函数将执行的结果返回到调用它的地方。
通过使用 return 语句就可以实现。
在使用 return 语句时，函数会停止执行，并返回指定的值。
语法格式如下所示：
function function_name():return_type { 
    // 语句
    return value; 
}

以下实例，我么将 lastName 设置为可选参数：
TypeScript
function buildName(firstName: string, lastName?: string) {
    if (lastName)
        return firstName + " " + lastName;
    else
        return firstName;
}

let result1 = buildName("Bob");  // 正确
let result2 = buildName("Bob", "Adams", "Sr.");  // 错误，参数太多了
let result3 = buildName("Bob", "Adams");  // 正确

## 可选属性
接口里的属性不全都是必需的。 
有些是只在某些条件下存在，或者根本不存在。 例如给函数传入的参数对象中只有部分属性赋值了。
带有可选属性的接口与普通的接口定义差不多，只是在可选属性名字定义的后面加一个?符号。如下所示：
interface Person {
  name: string;
  age?: number;
  gender?: number;
}


以下实例函数的参数 rate 设置了默认值为 0.50，调用该函数时如果未传入参数则使用该默认值：
TypeScript
function calculate_discount(price:number,rate:number = 0.50) { 
    var discount = price * rate; 
    console.log("计算结果: ",discount); 
} 
calculate_discount(1000) 
calculate_discount(1000,0.30)

函数的最后一个命名参数 restOfName 以 ... 为前缀，它将成为一个由剩余参数组成的数组，索引值从0（包括）到 restOfName.length（不包括）。
TypeScript
function addNumbers(...nums:number[]) {  
    var i;   
    var sum:number = 0; 
    
    for(i = 0;i<nums.length;i++) { 
       sum = sum + nums[i]; 
    } 
    console.log("和为：",sum) 
 } 
 addNumbers(1,2,3) 
 addNumbers(10,10,10,10,10)

## 匿名函数自调用
匿名函数自调用在函数后使用 () 即可： 
TypeScript
(function () { 
    var x = "Hello!!";   
    console.log(x)     
 })()
编译以上代码，得到以下 JavaScript 代码：
JavaScript
(function () { 
    var x = "Hello!!";   
    console.log(x)    
})()

## 构造函数
TypeScript 也支持使用 JavaScript 内置的构造函数 Function() 来定义函数：
语法格式如下：
var res = new Function ([arg1[, arg2[, ...argN]],] functionBody)
参数说明：
arg1, arg2, ... argN：参数列表。 
functionBody：一个含有包括函数定义的 JavaScript 语句的字符串。 
实例
TypeScript
var myFunction = new Function("a", "b", "return a * b"); 
var x = myFunction(4, 3); 
console.log(x);
编译以上代码，得到以下 JavaScript 代码：
JavaScript
var myFunction = new Function("a", "b", "return a * b"); 
var x = myFunction(4, 3); 
console.log(x);

## Lambda 函数
Lambda 函数也称之为箭头函数。
箭头函数表达式的语法比函数表达式更短。
函数只有一行语句：
( [param1, parma2,…param n] )=>statement;
实例
以下实例声明了 lambda 表达式函数，函数返回两个数的和： 
TypeScript
var foo = (x:number)=>10 + x 
console.log(foo(100))      //输出结果为 110
编译以上代码，得到以下 JavaScript 代码：
JavaScript
var foo = function (x) { return 10 + x; };
console.log(foo(100)); //输出结果为 110
输出结果为：
110
函数是一个语句块：
( [param1, parma2,…param n] )=> {

    // 代码块
}
实例
以下实例声明了 lambda 表达式函数，函数返回两个数的和：
TypeScript
var foo = (x:number)=> {    
    x = 10 + x 
    console.log(x)  
} 
foo(100)
编译以上代码，得到以下 JavaScript 代码：
JavaScript
var foo = function (x) {
    x = 10 + x;
    console.log(x);
};
foo(100);
输出结果为：
110
我们可以不指定函数的参数类型，通过函数内来推断参数类型: 
TypeScript
var func = (x)=> { 
    if(typeof x=="number") { 
        console.log(x+" 是一个数字") 
    } else if(typeof x=="string") { 
        console.log(x+" 是一个字符串") 
    }  
} 
func(12) 
func("Tom")
编译以上代码，得到以下 JavaScript 代码：
JavaScript
var func = function (x) {
    if (typeof x == "number") {
        console.log(x + " 是一个数字");
    }
    else if (typeof x == "string") {
        console.log(x + " 是一个字符串");
    }
};
func(12);
func("Tom");
输出结果为：
12 是一个数字
Tom 是一个字符串
单个参数 () 是可选的：
TypeScript
var display = x => { 
    console.log("输出为 "+x) 
} 
display(12)
编译以上代码，得到以下 JavaScript 代码：
JavaScript
var display = function (x) {
    console.log("输出为 " + x);
};
display(12);
输出结果为：
输出为 12
无参数时可以设置空括号：
TypeScript
var disp =()=> { 
    console.log("Function invoked"); 
} 
disp();
编译以上代码，得到以下 JavaScript 代码：
JavaScript
var disp = function () {
    console.log("调用函数");
};
disp();
输出结果为：
调用函数

声明一个联合类型：
TypeScript
var val:string|number 
val = 12 
console.log("数字为 "+ val) 
val = "Runoob" 
console.log("字符串为 " + val)

也可以将联合类型作为函数参数使用：
TypeScript
function disp(name:string|string[]) { 
        if(typeof name == "string") { 
                console.log(name) 
        } else { 
                var i; 
                for(i = 0;i<name.length;i++) { 
                console.log(name[i])
                } 
        } 
} 
disp("Runoob") 
console.log("输出数组....") 
disp(["Runoob","Google","Taobao","Facebook"])

## TypeScript 接口
接口是一系列抽象方法的声明，是一些方法特征的集合，这些方法都应该是抽象的，需要由具体的类去实现，然后第三方就可以通过这组抽象方法调用，让具体的类执行具体的方法。
TypeScript 接口定义如下：
interface interface_name { 
}
实例
以下实例中，我们定义了一个接口 IPerson，接着定义了一个变量 customer，它的类型是 IPerson。
customer 实现了接口 IPerson 的属性和方法。
TypeScript
interface IPerson { 
    firstName:string, 
    lastName:string, 
    sayHi: ()=>string 
} 

var customer:IPerson = { 
    firstName:"Tom",
    lastName:"Hanks", 
    sayHi: ():string =>{return "Hi there"} 
} 

console.log("Customer 对象 ") 
console.log(customer.firstName) 
console.log(customer.lastName) 
console.log(customer.sayHi())  

var employee:IPerson = { 
    firstName:"Jim",
    lastName:"Blakes", 
    sayHi: ():string =>{return "Hello!!!"} 
} 

console.log("Employee  对象 ") 
console.log(employee.firstName) 
console.log(employee.lastName)

## 接口和数组
接口中我们可以将数组的索引值和元素设置为不同类型，索引值可以是数字或字符串。
TypeScript
interface namelist { 
[index:number]:string
} 

var list2:namelist = ["John",1,"Bran"] // 错误元素 1 不是 string 类型
interface ages { 
[index:string]:number
} 

var agelist:ages; 
agelist["John"] = 15   // 正确 
agelist[2] = "nine"   // 错误

## 接口继承
接口继承就是说接口可以通过其他接口来扩展自己。
Typescript 允许接口继承多个接口。
继承使用关键字 extends。
单接口继承语法格式：
Child_interface_name extends super_interface_name
多接口继承语法格式：
Child_interface_name extends super_interface1_name, super_interface2_name,…,super_interfaceN_name

## 完整实例
以下实例创建来一个 Car 类，然后通过关键字 new 来创建一个对象并访问属性和方法：
TypeScript
class Car { 
   // 字段
   engine:string;    
   // 构造函数
   constructor(engine:string) { 
      this.engine = engine 
   }    
   // 方法
   disp():void { 
      console.log("函数中显示发动机型号  :   "+this.engine) 
   } 
} 

// 创建一个对象
var obj = new Car("XXSY1")
// 访问字段
console.log("读取发动机型号 :  "+obj.engine)  

// 访问方法
obj.disp()
编译以上代码，得到以下 JavaScript 代码：
JavaScript
var Car = /** @class */ (function () {
    // 构造函数
    function Car(engine) {
        this.engine = engine;
    }
    // 方法
    Car.prototype.disp = function () {
        console.log("函数中显示发动机型号  :   " + this.engine);
    };
    return Car;
}());
// 创建一个对象
var obj = new Car("XXSY1");
// 访问字段
console.log("读取发动机型号 :  " + obj.engine);
// 访问方法
obj.disp();

instanceof 运算符
instanceof 运算符用于判断对象是否是指定的类型，如果是返回 true，否则返回 false。
TypeScript
class Person{ } 
var obj = new Person() 
var isPerson = obj instanceof Person; 
console.log("obj 对象是 Person 类实例化来的吗？ " + isPerson);

## 类和接口
类可以实现接口，使用关键字 implements，并将 interest 字段作为类的属性使用。
以下实例红 AgriLoan 类实现了 ILoan 接口：
TypeScript
interface ILoan { 
   interest:number 
} 

class AgriLoan implements ILoan { 
   interest:number 
   rebate:number 

   constructor(interest:number,rebate:number) { 
      this.interest = interest 
      this.rebate = rebate 
   } 
} 

var obj = new AgriLoan(10,1) 
console.log("利润为 : "+obj.interest+"，抽成为 : "+obj.rebate )

此外对象也可以作为一个参数传递给函数，如下实例：
TypeScript
var sites = { 
    site1:"Runoob", 
    site2:"Google",
}; 
var invokesites = function(obj: { site1:string, site2 :string }) { 
    console.log("site1 :"+obj.site1) 
    console.log("site2 :"+obj.site2) 
} 
invokesites(sites)

interface IPoint { 
    x:number 
    y:number 
} 
function addPoints(p1:IPoint,p2:IPoint):IPoint { 
    var x = p1.x + p2.x 
    var y = p1.y + p2.y 
    return {x:x,y:y} 
} 

// 正确
var newPoint = addPoints({x:3,y:4},{x:5,y:1})  

// 错误 
var newPoint2 = addPoints({x:1},{x:4,y:3})

实例
IShape.ts 文件代码：
/// <reference path = "IShape.ts" /> 
export interface IShape { 
   draw(); 
}
Circle.ts 文件代码：
import shape = require("./IShape"); 
export class Circle implements shape.IShape { 
   public draw() { 
      console.log("Cirlce is drawn (external module)"); 
   } 
}
Triangle.ts 文件代码：
import shape = require("./IShape"); 
export class Triangle implements shape.IShape { 
   public draw() { 
      console.log("Triangle is drawn (external module)"); 
   } 
}
TestShape.ts 文件代码：
import shape = require("./IShape"); 
import circle = require("./Circle"); 
import triangle = require("./Triangle");  

function drawAllShapes(shapeToDraw: shape.IShape) {
   shapeToDraw.draw(); 
} 

drawAllShapes(new circle.Circle()); 
drawAllShapes(new triangle.Triangle());
使用 tsc 命令编译以上代码（AMD）：
tsc --module amd TestShape.ts 


