1.2 STL溜达组件 
1.容器（containers） 各种数据结构如vector,list,STL是一种class template
		vector <T>：一种向量。
		list <T>：一个双向链表容器，完成了标准 C++ 数据结构中链表的所有功能。
		queue <T>：一种队列容器，完成了标准 C++ 数据结构中队列的所有功能。
		stack <T>：一种栈容器，完成了标准 C++ 数据结构中栈的所有功能。
		deque <T>：双端队列容器，完成了标准 C++ 数据结构中栈的所有功能。
		priority_queue <T>：一种按值排序的队列容器。
		set <T>：一种集合容器。
		multiset <T>：一种允许出现重复元素的集合容器。
		map <key, val>：一种关联数组容器。
		multimap <key, val>：一种允许出现重复 key 值的关联数组容器。

2.算法（algorithms）	各种算法如sort ,seartch,copy,erase..STL是一种 function template.
		for_each()；
		find()；
		find_if()；
		count()；
		count_if()；
		replace()；
		replace_if()；
		copy()；
		unique_copy()；
		sort()；
		equal_range()；
		merge()；

3.迭代器（iterators）
4.仿函式（functors）行为类似函式
5.配接器（adapters）
6 配置器（allocators）

## C++容器（STL容器） ##

容器（container）用于存放数据的类模板。可变长数组、链表、平衡二叉树等数据结构在 STL 中都被实现为容器。

程序员使用容器时，即将容器类模板实例化为容器类时，会指明容器中存放的元素是什么类型的。

容器中可以存放基本类型的变量，也可以存放对象。对象或基本类型的变量被插入容器中时，实际插入的是对象或变量的一个复制品。

STL 中的许多算法（即函数模板），如排序、查找等算法，在执行过程中会对容器中的元素进行比较。这些算法在比较元素是否相等时通常用运算符进行，比较大小通常用<运算符进行，因此，被放入容器的对象所属的类最好重载==和<运算符，以使得两个对象用==和<进行比较是有定义的。

容器分为两大类。
顺序容器
顺序容器有以下三种：可变长动态数组 vector、双端队列 deque、双向链表 list。

它们之所以被称为顺序容器，是因为元素在容器中的位置同元素的值无关，即容器不是排序的。将元素插入容器时，指定在什么位置（尾部、头部或中间某处）插入，元素就会位于什么位置。
关联容器
关联容器有以下四种：set、multiset、map、multimap。关联容器内的元素是排序的。插入元素时，容器会按一定的排序规则将元素放到适当的位置上，因此插入元素时不能指定位置。

默认情况下，关联容器中的元素是从小到大排序（或按关键字从小到大排序）的，而且用<运算符比较元素或关键字大小。因为是排好序的，所以关联容器在查找时具有非常好的性能。

除了以上两类容器外，STL 还在两类容器的基础上屏蔽一部分功能，突出或增加另一部分功能，实现了三种容器适配器：栈 stack、队列 queue、优先级队列 priority_queue。

为称呼方便起见，本教程后面将容器和容器适配器统称为容器。

容器都是类模板。它们实例化后就成为容器类。用容器类定义的对象称为容器对象。

例如，vector<int>是一个容器类的名字，vector<int> a;就定义了一个容器对象 a，a 代表一个长度可变的数组，数组中的每个元素都是 int 类型的变量；vector<double> b;定义了另一个容器对象 b，a 和 b 的类型是不同的。本教程后文所说的“容器”，有时也指“容器对象”，读者需要根据上下文自行判别。

任何两个容器对象，只要它们的类型相同，就可以用 <、<=、>、>=、==、!= 进行词典式的比较运算。假设 a、b 是两个类型相同的容器对象，这些运算符的运算规则如下。
a == b：若 a 和 b 中的元素个数相同，且对应元素均相等，则a == b的值为 true，否则值为 false。元素是否相等是用==运算符进行判断的。
a<b：规则类似于词典中两个单词比较大小，从头到尾依次比较每个元素，如果发生 a 中的元素小于 b 中的元素的情况，则a<b的值为 true；如果没有发生 b 中的元素小于 a 中的元素的情况，且 a 中的元素个数比 b 少，a<b的值也为 true；其他情况下值为 false。元素比较大小是通过<运算符进行的。
a != b：等价于 !(a == b)。
a > b：等价于 b < a。
a <= b：等价于 !(b < a)。
a >= b：等价于 !(a < b)。

所有容器都有以下两个成员函数：
int size()：返回容器对象中元素的个数。
bool empty()：判断容器对象是否为空。

顺序容器和关联容器还有以下成员函数：
begin()：返回指向容器中第一个元素的迭代器。
end()：返回指向容器中最后一个元素后面的位置的迭代器。
rbegin()：返回指向容器中最后一个元素的反向迭代器。
rend()：返回指向容器中第一个元素前面的位置的反向迭代器。
erase(...)：从容器中删除一个或几个元素。该函数参数较复杂，此处省略。
clear()：从容器中删除所有元素。

如果一个容器是空的，则 begin() 和 end() 的返回值相等，rbegin() 和 rend() 的返回值也相等。

顺序容器还有以下常用成员函数：
front()：返回容器中第一个元素的引用。
back()：返回容器中最后一个元素的引用。
push_back()：在容器末尾增加新元素。
pop_back()：删除容器末尾的元素。
insert(...)：插入一个或多个元素。该函数参数较复杂，此处省略。

## STL算法详解 ##

STL 提供能在各种容器中通用的算法（大约有70种），如插入、删除、查找、排序等。算法就是函数模板。算法通过迭代器来操纵容器中的元素。

许多算法操作的是容器上的一个区间（也可以是整个容器），因此需要两个参数，一个是区间起点元素的迭代器，另一个是区间终点元素的后面一个元素的迭代器。例如，排序和查找算法都需要这两个参数来指明待排序或待查找的区间。

有的算法返回一个迭代器。例如，find 算法在容器中查找一个元素，并返回一个指向该元素的迭代器。

算法可以处理容器，也可以处理普通的数组。

有的算法会改变其所作用的容器。例如：
copy：将一个容器的内容复制到另一个容器。
remove：在容器中删除一个元素。
random_shuffle：随机打乱容器中的元素。
fill：用某个值填充容器。

有的算法不会改变其所作用的容器。例如：
find：在容器中查找元素。
count_if：统计容器中符合某种条件的元素的个数。

STL 中的大部分常用算法都在头文件 algorithm 中定义。此外，头文件 numeric 中也有一些算法。

下面介绍一个常用算法 find，以便对算法是什么、怎么用有一个基本的概念。find 算法和其他算法一样都是函数模板。find 模板的原型如下：
template <class InIt, class T>
InIt find(InIt first, InIt last, const T& val);

其功能可以是在迭代器 first、last 指定的容器的一个区间 [first, last) 中，按顺序查找和 val 相等的元素。如果找到，就返回该元素的迭代器；如果找不到，就返回 last。
[first, last) 这个区间是一个左闭右开的区间，即 last 指向的元素其实不在此区间内。
find 模板使用==运算符判断元素是否相等。因此，如果 [first, last) 区间中存放的是对象，则==运算符应该被适当重载，使得两个对象可以用==运算符比较。

注意：上一段话说的是“其功能可以是”，而不是“其功能就是”。这是因为模板只是一种代码形式，这种代码形式具体能完成什么功能，取决于程序员对该模板写法的了解及其想象力。按照语法，调用 find 模板时，first 和 last 只要类型相同就可以，不一定必须是迭代器。

演示 find 用法的程序如下：
#include <vector>
#include <algorithm>
#include <iostream>
using namespace std;
int main()  {
    int a[10] = {10,20,30,40};
    vector<int> v;
    v.push_back(1);    v.push_back(2);
    v.push_back(3);    v.push_back(4); //此后v里放着4个元素：1,2,3,4
    vector<int>::iterator p;
    p = find(v.begin(),v.end(),3); //在v中查找3
    if(p != v.end()) //若找不到,find返回 v.end()
        cout << "1) " <<  * p << endl; //找到了
    p = find(v.begin(),v.end(),9);
    if(p == v.end())
        cout << "not found " << endl; //没找到
    p = find(v.begin()+1,v.end()-1,4); //在,3 这两个元素中查找4
    cout << "2) " << * p << endl;
    int * pp = find(a,a+4,20);
    if(pp == a + 4)
        cout << "not found" << endl;
    else
        cout << "3) " <<* pp << endl;
}
程序的输出结果是：
1) 3
not found
2) 4
3) 20

第 11 行，要查找的区间是 [v.begin(), v.end())，v.end() 不在查找范围内，因此没有问题。本行的查找会成功，因此 p 指向找到的元素 3。

第 17 行，因为要查找的区间是 [v.begin()+l，v.end()-1)，这个区间中只有 2、3 这两个元素，因此查找会失败，p 的值变为 v.end() - 1，因此 p 正好指向 4 这个元素。

第 19 行，数组 a 是一个容器。数组名 a 的类型是 int *，可以做迭代器使用，表达式a+4的类型也是 int*，因此也能做迭代器。本次调用 find,查找区间是 [a, a+4)，即数组 a 的前 4 个元素。如果查找失败，find 就会返回 a+4。

STL 中还有一个常用的算法 sort，用于对容器排序，其原型为：
template<class_RandIt>
void sort(_RandIt first, _RandIt last);

该算法可以用来对区间 [first, last) 从小到大进行排序。下面两行程序就能对数组 a 排序：
int a[4] = {3, 4, 2, 1};
sort(a, a+4);

## STL中“大”、“小”和“相等”的概念 ##

STL 中关联容器内部的元素是排序的。STL 中的许多算法也涉及排序、查找。这些容器和算法都需要对元素进行比较，有的比较是否相等，有的比较元素大小。

在 STL 中，默认情况下，比较大小是通过<运算符进行的，和>运算符无关。在STL中提到“大”、“小”的概念时，以下三个说法是等价的：
x 比 y 小。
表达式x<y为真。
y 比 x 大。

一定要注意，y比x大意味着x<y为真，而不是y>x为真。y>x的结果如何并不重要，甚至y>x是没定义的都没有关系。

在 STL 中，x和y相等也往往不等价于x==y为真。对于在未排序的区间上进行的算法，如顺序查找算法 find，查找过程中比较两个元素是否相等用的是==运算符；但是对于在排好序的区间上进行查找、合并等操作的算法（如折半查找算法 binary_search，关联容器自身的成员函数 find）来说，x和y相等是与x<y和y<x同时为假等价的，与==运算符无关。看上去x<y和y<x同时为假就应该和x==y为真等价，其实不然。例如下面的 class A：
class A
{
    int v;
public:
    bool operator< (const A & a)const {return false;}
};
可以看到，对任意两个类 A 的对象 x、y，x<y和y<x都是为假的。也就是说，对 STL 的关联容器和许多算法来说，任意两个类 A 的对象都是相等的，这与==运算符的行为无关。

综上所述，使用 STL 中的关联容器和许多算法时，往往需要对<运算符进行适当的重载，使得这些容器和算法可以用<运算符对所操作的元素进行比较。最好将<运算符重载为全局函数，因为在重载为成员函数时，在有些编译器上会出错（由其 STL 源代码的写法导致）。

## C++ vector，STL vector（可变长的动态数组）详解 ##

vector 是顺序容器的一种。vector 是可变长的动态数组，支持随机访问迭代器，所有 STL 算法都能对 vector 进行操作。要使用 vector，需要包含头文件 vector。

在 vector 容器中，根据下标随机访问某个元素的时间是常数，在尾部添加一个元素的时间大多数情况下也是常数，总体来说速度很快。

在中间插入或删除元素时，因为要移动多个元素，因此速度较慢，平均花费的时间和容器中的元素个数成正比。

在 vector 容器中，用一个动态分配的数组来存放元素，因此根据下标访问某个元素的时间是固定的，与元素个数无关。

vector 容器在实现时，动态分配的存储空间一般都大于存放元素所需的空间。例如，哪怕容器中只有一个元素，也会分配 32 个元素的存储空间。这样做的好处是，在尾部添加一个新元素时不必重新分配空间，直接将新元素写入适当位置即可。在这种情况下，添加新元素的时间也是常数。

但是，如果不断添加新元素，多出来的空间就会用完，此时再添加新元素，就不得不重新分配内存空间，把原有内容复制过去后再添加新的元素。碰到这种情况，添加新元素所花的时间就不是常数，而是和数组中的元素个数成正比。

至于在中间插入或删除元素，必然涉及元素的移动，因此时间不是固定的，而是和元素个数有关。

vector 有很多成员函数，常用的如表 1 所示。

表1：vector中常用的成员函数
成员函数	作 用
vector()	无参构造函数，将容器初始化为空
vector(int n)	将容器初始化为有 n 个元素
vector(int n, const T & val)	假定元素的类型是 T，此构造函数将容器初始化为有 n 个元素，每 个元素的值都是 val
vector(iterator first, iterator last)	first 和 last 可以是其他容器的迭代器。一般来说，本构造函数初始化的结果就是将 vector 容器的内容变成与其他容器上的区间 [first, last) —致
void clear()	删除所有元素
bool empty()	判断容器是否为空
void pop_back()	删除容器末尾的元素
void push_back( const T & val)	将 val 添加到容器末尾
int size()	返回容器中元素的个数
T & front()	返回容器中第一个元素的引用
T & back()	返回容器中最后一个元素的引用
iterator insert(iterator i, const T & val)	将 val 插入迭代器 i 指向的位置，返回 i
iterator insert( iterator i, iterator first, iterator last)	将其他容器上的区间 [first, last) 中的元素插入迭代器 i 指向的位置
iterator erase(iterator i)	删除迭代器 i 指向的元素，返回值是被删元素后面的元素的迭代器
iterator erase(iterator first, iterator last)	删除容器中的区间 [first, last)
void swap( vector <T> & v)	将容器自身的内容和另一个同类型的容器 v 互换
下面的程序演示了 vector 的基本用法。

#include <iostream>
#include <vector>  //使用vector需要包含此头文件
using namespace std;
template <class T>
void PrintVector(const vector <T> & v)
{  //用于输出vector容器的全部元素的函数模板
    typename vector <T>::const_iterator i;
    //typename 用来说明 vector <T>::const_iterator 是一个类型，在 Visual Studio 中不写也可以
    for (i = v.begin(); i != v.end(); ++i)
        cout << *i << " ";
    cout << endl;
}
int main()
{
    int a[5] = { 1, 2, 3, 4, 5 };
    vector <int> v(a, a + 5);  //将数组a的内容放入v
    cout << "1) " << v.end() - v.begin() << endl;  //两个随机迭代器可以相减，输出：1)5
    cout << "2)"; PrintVector(v);  //输出：2)1 2 3 4 5
    v.insert(v.begin() + 2, 13);  //在 begin()+2 位置插人 13
    cout << "3)"; PrintVector(v);  //输出：3)1 2 13 3 4 5
    v.erase(v.begin() + 2);  //删除位于 begin()+2 位置的元素
    cout << "4)"; PrintVector(v);  //输出：4)1 2 3 4 5
    vector<int> v2(4, 100);  //v2 有 4 个元素，都是 100
    v2.insert(v2.begin(), v.begin() + 1, v.begin() + 3);  //将v的一段插入v2开头
    cout << "5)v2:"; PrintVector(v2);  //输出：5)v2:2 3 100 100 100 100
    v.erase(v.begin() + 1, v.begin() + 3);  //删除 v 上的一个区间，即 [2,3)
    cout << "6)"; PrintVector(v);  //输出：6)1 4 5
    return 0;
}

思考题：程序中的 PrintVector 模板演示了将容器的引用作为函数参数的用法。就完成输出整个容器内容这个功能来说，写成 PrintVector 模板这样是比较笨拙的，该模板的适用范围太窄。有没有更好的写法？

vector 还可以嵌套以形成可变长的二维数组。例如：
#include <iostream>
#include <vector>
using namespace std;
int main()
{   
    vector<vector<int> > v(3); //v有3个元素，每个元素都是vector<int> 容器
    for(int i = 0;i < v.size(); ++i)
        for(int j = 0; j < 4; ++j)
            v[i].push_back(j);
    for(int i = 0;i < v.size(); ++i) {
        for(int j = 0; j < v[i].size(); ++j)
            cout << v[i][j] << " ";
        cout << endl;
    }
    return 0;
}
程序的输出结果是：
0 1 2 3
0 1 2 3
0 1 2 3

vector< vector<int> > v(3);定义了一个 vector 容器，该容器中的每个元素都是一个 vector <int> 容器。即可以认为，v 是一个二维数组，一共 3 行，每行都是一个可变长的一维数组。

在 Dev C++ 中，上面写法中 int 后面的两个>之间需要有空格，否则有的编译器会把它们当作>>运算符，编译会出错。

## C++ list，STL list（双向链表）详解 ##

list 是顺序容器的一种。list 是一个双向链表。使用 list 需要包含头文件 list。双向链表的每个元素中都有一个指针指向后一个元素，也有一个指针指向前一个元素，如图1所示。

在 list 容器中，在已经定位到要增删元素的位置的情况下，增删元素能在常数时间内完成。如图2所示，在 ai 和 ai+1 之间插入一个元素，只需要修改 ai 和 ai+1 中的指针即可。

````
图1 ：双向链表


图2：在双向链表中插入元素

list 容器不支持根据下标随机存取元素。

list 的构造函数和许多成员函数的用法都与 vector 类似，此处不再列举。除了顺序容器都有的成员函数外，list 容器还独有如表 1 所示的成员函数（此表不包含全部成员函数，且有些函数的参数较为复杂，表中只列出函数名）。

表1：list 的成员函数
成员函数或成员函数模板	作  用
void push_front(const T & val)	将 val 插入链表最前面
void pop_front()	删除链表最前面的元素
void sort()	将链表从小到大排序
void remove (const T & val)	删除和 val 相等的元素
remove_if	删除符合某种条件的元素
void unique()	删除所有和前一个元素相等的元素
void merge(list <T> & x)	将链表 x 合并进来并清空 x。要求链表自身和 x 都是有序的
void splice(iterator i, list <T> & x, iterator first, iterator last)	在位置 i 前面插入链表 x 中的区间 [first, last)，并在链表 x 中删除该区间。链表自身和链表 x 可以是同一个链表，只要 i 不在 [first, last) 中即可
表1中列出的成员函数有些是重载的，如 unique、merge、splice 成员函数都不止一个， 这里不再一一列举并解释。后面对于其他容器以及算法的介绍，对于有重载的情况也不再指出。要详细了解 STL，还需要查阅专门的 STL 手册，或查看编译器提供的联机帮助。

STL 中的算法 sort 可以用来对 vector 和 deque 排序，它需要随机访问迭代器的支持。因为 list 不支持随机访问迭代器，所以不能用算法 sort 对 list 容器排序。因此，list 容器引入了 sort 成员函数以完成排序。

list 的示例程序如下：
#include <list>  //使用 list 需要包含此头文件
#include <iostream>
#include <algorithm>  //使用STL中的算法需要包含此头文件
using namespace std;
class A {
private: int n;
public:
    A(int n_) { n = n_; }
    friend bool operator < (const A & a1, const A & a2);
    friend bool operator == (const A & a1, const A & a2);
    friend ostream & operator << (ostream & o, const A & a);
};
bool operator < (const A & a1, const A & a2) {
    return a1.n < a2.n;
}
bool operator == (const A & a1, const A & a2) {
    return a1.n == a2.n;
}
ostream & operator << (ostream & o, const A & a) {
    o << a.n;
    return o;
}
template <class T>
void Print(T first, T last)
{
    for (; first != last; ++first)
        cout << *first << " ";
    cout << endl;
}
int main()
{
    A a[5] = { 1, 3, 2, 4, 2 };
    A b[7] = { 10, 30, 20, 30, 30, 40, 40 };
    list<A> lst1(a, a + 5), lst2(b, b + 7);
    lst1.sort();
    cout << "1)"; Print(lst1.begin(), lst1.end());  //输出：1)1 2 2 3 4
    lst1.remove(2);  //删除所有和A(2)相等的元素
    cout << "2)"; Print(lst1.begin(), lst1.end());  //输出：2)1 3 4
    lst2.pop_front();  //删除第一个元素
    cout << "3)"; Print(lst2.begin(), lst2.end());  //输出：3)30 20 30 30 40 40
    lst2.unique();  //删除所有和前一个元素相等的元素
    cout << "4)"; Print(lst2.begin(), lst2.end());  //输出：4)30 20 30 40
    lst2.sort();
    lst1.merge(lst2);  //合并 lst2 到 lst1 并清空 lst2
    cout << "5)"; Print(lst1.begin(), lst1.end());  //输出：5)1 3 4 20 30 30 40
    cout << "6)"; Print(lst2.begin(), lst2.end());  //lst2是空的，输出：6)
    lst1.reverse();  //将 lst1 前后颠倒
    cout << "7)"; Print(lst1.begin(), lst1.end());  //输出 7)40 30 30 20 4 3 1
    lst2.insert(lst2.begin(), a + 1, a + 4);  //在 lst2 中插入 3,2,4 三个元素
    list <A>::iterator p1, p2, p3;
    p1 = find(lst1.begin(), lst1.end(), 30);
    p2 = find(lst2.begin(), lst2.end(), 2);
    p3 = find(lst2.begin(), lst2.end(), 4);
    lst1.splice(p1, lst2, p2, p3);  //将[p2, p3)插入p1之前，并从 lst2 中删除[p2,p3)
    cout << "8)"; Print(lst1.begin(), lst1.end());  //输出：8)40 2 30 30 20 4 3 1
    cout << "9)"; Print(lst2.begin(), lst2.end());  //输出：9)3 4
    return 0;
}

【实例】用 list 解决约瑟夫问题。

约瑟夫问题是：有 n 只猴子，按顺时针方向围成一圈选大王（编号为 1~n），从第 1 号开始报数，一直数到 m，数到 m 的猴子退到圈外，剩下的猴子再接着从 1 开始报数。就这样，直到圈内只剩下一只猴子时，这个猴子就是猴王。编程求输入 n、m 后,输出最后猴王的编号。

输入数据：每行是用空格分开的两个整数，第一个是 n，第二个是 m（0<m, n<=1 000 000）。最后一行是：
0 0

输出要求：对于每行输入数据（最后一行除外），输出数据也是一行，即最后猴王的编号。

输入样例：
6 2
12 4
8 3
0 0

输出样例：
5
1
7

示例程序如下：


#include <list>
#include <iostream>
using namespace std;
int main()
{
    list<int> monkeys;
    int n, m;
    while (true) {
        cin >> n >> m;
        if (n == 0 && m == 0)
            break;
        monkeys.clear();  //清空list容器
        for (int i = 1; i <= n; ++i)  //将猴子的编号放入list
            monkeys.push_back(i);
        list<int>::iterator it = monkeys.begin();
        while (monkeys.size() > 1) { //只要还有不止一只猴子，就要找一只猴子让其出列
            for (int i = 1; i < m; ++i) { //报数
                ++it;
                if (it == monkeys.end())
                    it = monkeys.begin();
            }
            it = monkeys.erase(it); //删除元素后，迭代器失效，
                                    //要重新让迭代器指向被删元素的后面
            if (it == monkeys.end())
                it = monkeys.begin();
        }
        cout << monkeys.front() << endl; //front返回第一个元素的引用
    }
    return 0;
}




----------
erase 成员函数返回被删除元素后面那个元素的迭代器。如果被删除的是最后一个元素，则返回 end()。

这个程序也可以用 vector 实现，但是执行速度要慢很多。因为 vector 的 erase 操作牵涉元素的移动，不能在常数时间内完成，所花费的时间和容器中的元素个数有关；而 list 的 erase 操作只是修改几个指针而已，可以在常数时间内完成。当 n 很大（数十万）时，两种写法在速度上会有明显区别。

