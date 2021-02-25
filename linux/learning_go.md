多个 var 声明可以成组，const 和 import 同样允许这么做。

    var (
    	x int
    	b bool
    )

一个特殊的变量名是 _（下划线）。任何赋给它的值都被丢弃。
    
    _, b := 34, 35

Go 的编译器对声明却未使用的变量在报错。

**数字类型**

Go 有众所周知的类型如 int，这个类型根据你的硬件决定适当的长度。意味着在 32 位硬件上，是 32 位的；在 64 位硬件上是 64 位的。如果你希望明确其长度，你可以使用 int32 或者 uint32。完整的整数类型列表（符号和无符号）是 int8，int16，int32，int64和 byte，uint8，uint16，uint32，uint64。byte是 uint8 的别名。浮点类型的值有 float32 和 float64 （没有 float 类型）。64 位的整数和浮点数总是 64 位的，即便是在 32 位的架构上。

**常量**

常量在 Go 中，也就是 constant。它们在编译时被创建，只能是数字、字符串或布尔
值；const x = 42 生成 x 这个常量。可以使用 iota b 生成枚举值。

    const (
    a = iota
    b = iota
    )

第一个 iota 表示为 0，因此 a 等于 0，当 iota 再次在新的一行使用时，它的值增加了 1，因此 b 的值是 1。

**字符串**

另一个重要的内建类型是 string。赋值字符串的例子：

    s := "Hello World!"

字符串在 Go 中是 UTF-8 的由双引号（ ”）包裹的字符序列。如果你使用单引号（ ’）则表示一个字符（ UTF-8编码）——这种在 Go 中不是 string。
一旦给变量赋值，字符串就不能修改了：在 Go 中字符串是不可变的。从 C 来的用户，下面的情况在 Go 中是非法的。

    var s string = "hello"

s[0] = 'c' ← 修改第一个字符为'c'，这会报错

在 Go 中实现这个，需要下面的方法：

    s := "hello"
    c := []byte(s)// 0.
    c[0] = 'c' //1.
    s2 := string(c) //2.
    fmt.Printf("%s\n", s2) //3.

0. 转换s 为字节数组，查阅在第5 章”转换”节、63 页的内容；
1. 修改数组的第一个元素；
2. 创建新的字符串s2 保存修改；
3. 用fmt.Printf 函数输出字符串。

**控制结构**

Go 有 goto 语句——明智的使用它。
循环嵌套循环时，可以在 break 后指定标签。用标签决定哪个循环被终止：

它不会匹配失败后自动向下尝试，但是可以使用fallthrough使其这样做。没有 fallthrough：

    switch i {
	    case 0: // 空的case 体
	    case 1:
	    f() // 当i == 0 时，f 不会被调用！
    }

    而这样：

    switch i {
	    case 0: fallthrough
	    case 1:
	    f() // 当i == 0 时，f 会被调用！
    }

    分支可以使用逗号分隔的列表。
    func shouldEscape(c byte) bool {
	    switch c {
		    case ' ', '?', '&', '=', '#', '+': ← , as "or"
		    return true
	    }
	    return false
    }