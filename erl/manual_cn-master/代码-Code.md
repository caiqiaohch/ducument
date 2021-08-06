# 代码 | Code

用于管理代码编译，代码评估和代码加载的实用程序。

该模块补充了Erlang的[`:code`模块](http://www.erlang.org/doc/man/code.html)，添加了Elixir特有的行为。几乎这个模块中的所有功能都对Elixir的行为有全局性的副作用。

## 功能

append_path(path)



在Erlang VM代码路径列表的末尾附加一个路径

available_compiler_options()



用可用的编译器选项返回一个列表

compile_quoted(quoted, file \ "nofile")



编译引用的表达式

compile_string(string, file \ "nofile")



编译给定的字符串

compiler_options()



从代码服务器获取编译选项

compiler_options(opts)



设置编译选项

delete_path(path)



从Erlang VM代码路径列表中删除路径。这是Erlang VM用于查找模块代码的目录列表

ensure_compiled(module)



确保给定的模块被编译和加载

ensure_compiled?(module)



确保给定的模块被编译和加载

ensure_loaded(module)



确保给定的模块已加载

ensure_loaded?(module)



确保给定的模块已加载

eval_file(file, relative_to \ nil)



等待给定的文件

eval_quoted(quoted, binding \ [], opts \ [])



评估报价内容

eval_string(string, binding \ [], opts \ [])



评估给出的内容 `string`

get_docs(module, kind)



返回给定模块的文档

load_file(file, relative_to \ nil)



加载给定的文件

loaded_files()



列出所有加载的文件

prepend_path(path)



在Erlang VM代码路径列表的开始处添加一条路径

require_file(file, relative_to \ nil)



需要给定的文件

string_to_quoted（string，opts \ []）

将给定的字符串转换为其引用形式

string_to_quoted!(string, opts \ [])



将给定的字符串转换为其引用形式

unload_files（文件）

从加载的文件列表中删除文件

### **append_path(path)**



在Erlang VM代码路径列表的末尾附加一个路径。

这是ErlangVM用于查找模块代码的目录列表。

路径`Path.expand/1`在被追加之前被扩展。如果此路径不存在，则返回错误。

#### 实例

```javascript
Code.append_path(".") #=> true

Code.append_path("/does_not_exist") #=> {:error, :bad_directory}
```

### **available_compiler_options()**

返回带有可用编译器选项的列表。

查看`Code.compiler_options/1`更多信息。

#### 实例

```javascript
iex> Code.available_compiler_options
[:docs, :debug_info, :ignore_module_conflict, :relative_paths, :warnings_as_errors]
```

### **compile_quoted(quoted, file \ "nofile")**



编译引用的表达式。

返回一个元组列表，其中第一个元素是模块名称，第二个元素是它的字节码（作为二进制文件）。

### **compile_string(string, file \ "nofile")**

编译给定的字符串。

返回一个元组列表，其中第一个元素是模块名称，第二个元素是它的字节码（作为二进制文件）。

要一次编译多个文件，请检查`Kernel.ParallelCompiler.files/2`。

### **compiler_options()**



从代码服务器获取编译选项。

检查`compiler_options/1`更多信息。

#### 实例

```javascript
Code.compiler_options
#=> %{debug_info: true, docs: true,
      warnings_as_errors: false, ignore_module_conflict: false}
```

### compiler_options（选）

设置编译选项。

这些选项是全球性的，因为它们是由Elixir的代码服务器存储的。

可供选择的办法有：

- ：docs - 如果为true，则保留编译模块中的文档，默认为true

- ：debug_info - 如果为true，则保留编译模块中的调试信息; 这允许开发人员重建原始源代码，默认为false

- ：ignore_module_conflict - 如果为true，则覆盖已经定义但不会引发错误的模块，默认为false

- ：relative_paths - 如果为true，则在带引号的节点中使用相对路径，编译器生成的警告和错误，默认情况下为true。 注意禁用此选项不会影响运行时警告和错误。

：warnings_as_errors - 在生成警告时导致编译失败它将返回编译器选项的新表.ExamplesCode.compiler_options（debug_info：true）＃=>％{debug_info：true，docs：true，

​    warnings_as_errors：false，ignore_module_conflict：false} delete_path（路径）从Erlang VM代码路径列表中删除路径。 这是Erlang VM用于查找模块代码的目录列表。在删除之前，路径将扩展为Path.expand / 1。 如果路径不存在，则返回false。

ExamplesCode.prepend_path(".") Code.delete_path(".") #=> true  Code.delete_path("/does_not_exist") #=> falseensure_compiled(module)ensure_compiled(module) ::   {:module, module} |   {:error, :embedded | :badfile | :nofile | :on_load_failure}

确保给定的模块被编译和加载。如果模块已经加载，它将作为no-op运行。 如果模块尚未加载，它会检查是否需要先编译它，然后尝试加载它。如果它成功加载模块，则返回{：module，module}。 如果没有，则返回错误原因的{：error，reason}。有关模块加载和何时使用ensure_loaded / 1或ensure_compiled / 1.ensure_compiled？（模块）的详细信息，请检查ensure_loaded / 1 ensure_compiled？（module）:: booleanEnsures 给定的模块被编译并加载。类似于ensure_compiled / 1，但是如果模块已经加载或成功加载和编译，则返回true。 否则返回false。

ensure_loaded(module)ensure_loaded(module) ::   {:module, module} |   {:error, :embedded | :badfile | :nofile | :on_load_failure}

确保给定的模块已加载。如果模块已经加载，则该模块不工作。如果模块尚未加载，则会尝试加载它。如果它成功加载模块，则返回{：module，module}。如果没有，则返回错误原因{：error，reason}。在Erlang VMErlang上加载代码有两种加载代码的模式：交互式和嵌入式。默认情况下，Erlang虚拟机以交互模式运行，其中根据需要加载模块。在嵌入模式下，发生相反情况，因为所有模块都需要预先加载或明确加载。因此，此功能用于在使用模块之前检查模块是否已加载，并允许模块作出相应的反应。例如，URI模块使用此函数来检查给定的URI scheme是否存在特定的解析器.ensure_compiled / 1Elixir还包含一个ensure_compiled / 1函数，它是ensure_loaded / 1的超集。由于Elixir的编译并行发生您可能需要使用尚未编译的模块，因此它甚至不能被加载。当调用时，ensure_compiled / 1暂停调用者的编译，直到给予ensure_compiled / 1的模块变为可用或用于目前的项目已经编译完成。如果编译完成并且模块不可用，则会返回错误元组.resure_compiled / 1不适用于依赖项，因为依赖项必须预先编译。在大多数情况下，ensure_loaded / 1就足够了。在少数情况下must_compiled / 1必须使用，通常涉及需要调用模块回调信息的宏。示例x> Code.ensure_loaded（Atom）

{：module，Atom}

iex> Code.ensure_loaded（DoesNotExist）

{：error，：nofile} ensure_loaded？（模块）确保给定模块已加载。类似于ensure_loaded / 1，但如果模块已加载或已成功加载，则返回true。否则返回false.Examplesiex> Code.ensure_loaded？（Atom）

trueeval_file（file，relative_to \ nil）等于给定的文件。接受relative_to作为参数以告知文件的位置。当load_file加载文件并返回加载的模块及其字节代码时，eval_file只是评估文件内容并返回评估结果及其bindings.eval_quoted（引用，binding \ []，opts \ []）计算引用的内容。警告：在宏内调用此函数被认为是不好的做法，因为它会在编译时尝试评估运行时值。宏参数通常通过将它们引用到返回的引用表达式中（而不是评估）来转换。有关绑定和选项的说明，请参阅eval_string / 3。

Examplesiex> contents = quote(do: var!(a) + var!(b)) iex> Code.eval_quoted(contents, [a: 1, b: 2], file: __ENV__.file, line: __ENV__.line) {3, [a: 1, b: 2]}

评估由string给出的内容。绑定参数是变量绑定的关键字列表。 opts参数是环境选项的关键字列表。警告：字符串可以是任何Elixir代码，并且将以与Erlang VM相同的权限执行：这意味着此类代码可能会危害计算机（例如通过执行系统命令）。 不要将eval_string / 3用于不受信任的输入（例如来自网络的字符串）.OptionsOptions可以是：



- `:file`  - 评估中要考虑的文件 

- `:line`  - 脚本开始的行 

另外，可以配置以下范围值：

- `:aliases`  - 具有别名及其目标的元组列表

- `:requires`  - 需要的模块列表

- `:functions` - 第一个元素是模块的元组列表，第二个是导入的函数名称和元组列表; 函数名称和参数列表必须进行排序

- `:macros` - 第一个元素是模块的元组列表，第二个是导入的宏名称和元组列表; 函数名称和参数列表必须进行排序

请注意，设置上述任何值都会覆盖Elixir的默认值。 例如，设置：需要[]，将不再自动需要内核模块; 以相同的方式设置：宏将不再像例如/ 2，case / 2等那样自动导入内核宏

返回格式为{value，binding}的元组，其中value是从评估字符串返回的值。 如果在评估字符串时发生错误，则会引发异常。

绑定是一个关键字列表，其中包含评估字符串后所有变量绑定的值。 绑定键通常是一个原子，但它可能是在不同上下文中定义的变量的元组。

#### 实例

```javascript
iex> Code.eval_string("a + b", [a: 1, b: 2], file: __ENV__.file, line: __ENV__.line)
{3, [a: 1, b: 2]}

iex> Code.eval_string("c = a + b", [a: 1, b: 2], __ENV__)
{3, [a: 1, b: 2, c: 3]}

iex> Code.eval_string("a = a + b", [a: 1, b: 2])
{3, [a: 3, b: 2]}
```

为方便起见，您可以传递__ENV __ / 0作为opts参数，并且当前环境中定义的所有导入，要求和别名将自动结束：

```javascript
iex> Code.eval_string("a + b", [a: 1, b: 2], __ENV__)
{3, [a: 1, b: 2]}
```

### **get_docs(module, kind)**

返回给定模块的文档。

当给定模块名称时，它会找到它的BEAM代码并从中读取文档。

给出.beam文件的路径时，它将直接从该文件加载文档。

返回值取决于`kind`值：

- `:docs`- 使用该`@doc`属性附加到函数和宏的所有文档字符串的列表

- `:moduledoc`- 元组`{, }`其中`line`是模块定义开始的行，并且`doc`是使用该`@moduledoc`属性附加到模块的字符串

- `:callback_docs`- 附加到`@callbacks`使用该`@doc`属性的所有文档字符串列表

- `:type_docs`- `@type`使用该`@typedoc`属性附加到回调的所有文档字符串列表

：all - 包含以下内容的关键字列表：docs和：moduledoc，：callback_docs和：type_docs.如果无法找到该模块，则返回nil.Examples＃获取模块文档

iex> {_line，text} = Code.get_docs（Atom，：moduledoc）

iex> String.split（text，“\ n”）|> Enum.at（0）

“用于处理原子的便利功能。”

＃模块不存在

iex> Code.get_docs（ModuleNotGood，：all）

nilload_file（file，relative_to \ nil）加载给定的文件。接受relative_to作为参数来告诉文件位于何处。如果文件已经被需要/加载，则加载它。它返回文件中定义的每个模块的元组列表{ModuleName，<< byte_code >>}。如果load_file被不同进程并发调用，目标文件将被同时加载多次。如果不想同时加载文件，请检查require_file / 2 .ExamplesCode.load_file（“eex_test.exs”，“../eex/test”）|> List.first

＃=> {EExTest.Compiled，<< 70,79,82,49，... >>} loaded_files（）列出所有已加载的文件.ExamplesCode.require_file（“../ eex / test / eex_test.exs”）

List.first（Code.loaded_files）=〜“eex_test.exs”＃=> trueprepend_path（path）在Erlang VM代码路径列表的开始处添加一个路径。这是Erlang VM用于查找模块代码的目录列表在被预先占用之前，路径扩展为Path.expand / 1。如果此路径不存在，则返回错误.ExamplesCode.prepend_path（“。”）＃=> true



Code.prepend_path（“/ does_not_exist”）＃=> {：error，：bad_directory} require_file（file，relative_to \ nil）需要给定的文件。接受relative_to作为参数来告诉文件的位置。返回值与load_file / 2的返回值相同。如果文件已经被要求/加载，那么require_file不会执行任何操作并返回nil。注意如果require_file被不同的进程同时调用，那么第一个调用require_file的进程会获得一个锁，剩下的将会阻塞，直到文件可用。也就是说，如果require_file被给定文件调用N次，它将只加载一次。调用require_file的第一个进程将获取已加载模块的列表，其他进程将得到nil。如果要多次加载文件，请检查load_file / 2。另请参见unload_files / 1示例如果代码已加载，则返回nil：Code.require_file（“eex_test.exs”，“../eex/test”）＃=> nil如果代码尚未加载，则返回值与load_file / 2：Code.require_file（“eex_test.exs”，“../eex/test”）|> List.first

＃=> {EExTest.Compiled，<< 70,79,82,49，... >>} string_to_quoted（string，opts \ []）将给定字符串转换为其引用形式。若它会成功，返回{：ok，quoted_form}。否则返回{:error, {line, error, token}}

。选项

- `:file`- 在堆栈跟踪中使用的文件名和在`__ENV__/0`宏中报告的文件

- ：行 - 在__ENV __ / 0宏中报告的行

- ：existing_atoms_only - 如果为true，则在标记器找到不存在的原子时引发错误

#### Macro.to_string / 2

将字符串`Macro.to_string/2`转换为引用形式的反义词是将引用的表单转换为字符串/二进制表示形式。

### **string_to_quoted!(string, opts \ [])**



将给定的字符串转换为其引用形式。

如果成功则返回ast，否则引发异常。 如果令牌丢失（通常是因为表达式不完整），则为TokenMissingError，否则为SyntaxError。

检查`string_to_quoted/2`选项信息。

### **unload_files(files)**

从加载的文件列表中删除文件。

文件中定义的模块不会被删除; 调用此函数只会将它们从列表中删除，从而使它们再次被需要。

#### 实例

```javascript
# Load EEx test code, unload file, check for functions still available
Code.load_file("../eex/test/eex_test.exs")
Code.unload_files(Code.loaded_files)
function_exported?(EExTest.Compiled, :before_compile, 0) #=> true
```

本文档系腾讯云云+社区成员共同维护，如有问题请联系 yunjia_community@tencent.com