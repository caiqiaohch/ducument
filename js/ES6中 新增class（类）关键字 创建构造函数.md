# ES6中 新增class（类）关键字 创建构造函数
## class的基本语法：
class它跟普通构造函数的一个主要区别：
class必须使用new调用，不用new调用会报错。普通构造函数不用new也可以执行。

constructor方法
constructor方法是类的默认方法，通过new命令生成对象实例时，自动调用该方法。一个类必须有constructor方法，如果没有写constructor方法，会默认添加个空的constructor方法。

class Point {  }
// 等同于
class Point {
  constructor() {}
}

类可以让 构造函数和方法成为一个整体 从逻辑上说更合理

class Point {
 	 constructor() { }
	 print() { 
	 }
}

## 类的特点
1.类的声明不会被提升，和let const 一样，有临时性死区
2.类的所有代码全都是在严格模式中执行
3.类的所有方法都是不可枚举的
4.类的所有方法都无法当成构造函数直接使用
5.类的构造器必须使用new 来调用

const b = Person();//这里会报错

6.可以使用getter 和 setter
getter取值的时候必须走进来 get 没有参数
setter 设置值得之后必须走进来 set 必须接收一个参数
get set 控制的属性不在原型上 而是在自己的属性上面
ES5的写法：

 Object.defineProperty(this,"age", {
	set(age){	},
	get(){   }
 })

7.可以使用static 关键字添加静态成员 和字段初始器（es7）
但是初始化的工作，如果没有使用static，就是实例成员

class Dog{
	constructor(name){
		this.name = name;
	 }
	length = 80;//是实例成员
	static age= 5;   //添加静态成员
	static method = function(){}
	print = () => {    //不会存放在原型上面，会占用一定的存储空间
			console.log(this.a)
	}
}
//1.使用static添加字段初始器，添加的是静态成员
//2.没有使用，则位于对象上
//3.箭头函数在字段初始器位置上，指向当前对象

8.类表达式
class（类）其实是一个表达式 可以写成类表达式

const A = class{   //匿名类，类表达式，类在js中本身就是表达式
	a = 1;
	b = 2;
}
const a = new A();
console.log(a)

## 类的继承
extends 继承，
extends 只能用于类中的定义 不能用与普通的构造函数中

super （ES6 中的要求 ：子类的构造函数必须执行一次super函数。）
super有两种用法
1.直接当成函数调用，表示父类的构造
如果定义了constructor 并表示这个是子类，则必须在constructor的第一行手动调用父类的构造函数.
如果说子类不写constructor，则会有默认的构造器，自动去调用父类的构造器

	class Animal{
	 	constructor(type,name,age,sex){
	 		this.type = type;
	 		this.name = name;
	 		this.age = age;
	 		this.sex = sex;
	 	}
	 	print(){
	 		console.log(`种类 ： ${this.type}`)
	 		console.log(`名字 ： ${this.name}`)
	 		console.log(`年龄 ： ${this.age}`)
	 		console.log(`性别 ： ${this.sex}`)
	 	}
	 }
	 class Dog extends Animal{
	 	constructor(name,age,sex){
	 		super("犬类",name,age,sex)
	   }
	 }

	const d = new Dog("旺财",5,"公");
	console.log(d);
	d.print();

2.super如果说当成对象使用，则表示父类的原型
super.inti() 这表示调用父类的inti方法

	class Dog extends Animal{
		print(){   //
			super.print();
		}
	}
	const d = new Dog("旺财",5,"公");
	console.log(d);
	d.print();//和普通构造函数一样父类和自身都拥有相同的属性名优先使用自身的

符号Symbol （ ES6里面新增的数据类型 ，以前没有这块的内容）
Symbol 就是一个新增数据类型

## 符号Symbol创建
const syb1 = Symbol();   //创建了一个符号
const syb2 = Symbol("asdfsdf");
console.log(typeof syb1)  //symbol

符号的特点
1.没有字面量的写法 只能使用symbol（）
2.新的数据类型，typeof返回的是symbol
3.每次去调用Symbol函数得到的符号永远不会相等，不管符号描述是否相同

     const syb1 = Symbol("abc");   
     const syb2 = Symbol("abc");
     console.log(syb1,syb2)
     console.log(syb1 == syb2 )//false

4.符号可以作为对象的属性名使用，这种属性名叫符号属性

    const syb1 = Symbol("abc");  
    const obj = {
    	[syb1] : 3    //符号属性
    }
    console.log(obj)

5.符号属性是不能被枚举的

	const syb1 = Symbol("abc");  
	 const obj = {
	 	a : 1,
	 	b : 2,
		[syb1] : 3    //符号属性
	 }
	 console.log(obj)//不显示符号属性的

6.针对符号属性 getOwnPropertySymbols(obj)
getOwnPropertySymbols(obj) 获取符号的属性方法 返回数组

	console.log(Object.getOwnPropertySymbols(obj))

7.符号类型无法被隐式转换，数学运算，字符串拼接都是不行的
可以进行内部的显式转换 最显著的就是console.log的输出

	const syb = Symbol();
	console.log(syb);
	console.log(syb + 10)；//都是报错

8.共享符号for（）
Symbol.for(“符号描述”) 如果符号描述相等，则可以得到同一个符号

	const syb1 = Symbol.for("abc");   
	const syb2 = Symbol.for("abc");
	console.log(syb1 === syb2) //true
