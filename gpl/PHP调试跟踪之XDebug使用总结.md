PHP调试跟踪之XDebug使用总结

PHP调试跟踪之XDebug使用总结：

Xdebug是一个开源的PHP程序调试工具，可以使用它来调试、跟踪及分析程序运行状态。当然，Xdebug需要结合PHP的编辑工具来打断点、跟踪、调试及分析，比较常用的PHP的Xdebug调试环境：Vim +Xdebug。

 

·     安装配置

·     调试环境

·     跟踪分析

·     注意事项

·     遇到问题

 

一、安装配置

1、安装

Xdebug的安装是作为PHP的拓展而存在的，所以可参考PHP拓展文章：

http://blog.csdn.net/why_2012_gogo/article/details/51120645

 

2、配置

php.ini:

[xdebug]

;基本调试配置

xdebug.auto_trace = on

xdebug.collect_params = on

xdebug.collect_return = on

xdebug.profiler_enable = on

xdebug.profiler_output_dir ="/php/ext/xdebug_profilers"

xdebug.trace_output_dir = "/tmp/ext/xdebug_traces"

;远程调试设置

xdebug.remote_enable = on

xdebug.remote_host = localhost

xdebug.remote_port = 9010

xdebug.remote_autostart = on

 

zend_extension=/usr/local/lib/php/extensions/no-debug-non-zts-20131226/xdebug.so

 

NOTE:

上面罗列的是最为常用的配置选项，至于其他配置选项及对应的含义，请参考：

https://xdebug.org/docs/all_settings#auto_trace

 

二、调试环境

Vim + Xdebug:

1、下载

http://www.vim.org/scripts/script.php?script_id=1929

2、配置

$ cd  ~

$ sudo mkdir ~/.vim

将上面下载的xdebug的plugin中文件复制到.vim下：

$ sudo cp –r /php/ext/plugin  .

在用户主目录下创建.vimrc文件：

$ sudo touch ／usr/share/vim/vimrc  ~/.vimrc

$ sudo vim ~/.vimrc

为.vimrc添加以下内容：

let g:debuggerPort = 9010（该端口必须与xdebug.remote_port相同）

let g:debuggerMaxDepth = 5（代表数组调试深度配置）

 

NOTE:

vimrc文件是vim的主要配置文件，它包含两个版本：全局版本和用户版本，我们建议修改用户版本的vimrc配置文件，这两种版本的路径可在vim普通模式下查看，如下：

 

全局版本路径查看：

$ sudo vim

$ :echo $VIM

路径地址：/usr/share/vim

 

用户版本路径查看：

$ sudo vim

$ :echo $HOME

路径地址：$HOME（pwd ~）

 

注意：

g:debuggerPort的端口号，必须与xdebug.remote_port相同；

g:debuggerMaxDepth代表的是脚本调试的最大深度层次；

 

最后，修改完php.ini、.vimrc配置后，记得重启php-fpm。

 

3、调试

A、准备一个php文件

<?php

 $value = '马上使用XDebug调试程序，你准备好了吗';

 echo $value;

?>

将上面的文件放入到你的Web根目录下，我的访问地址是：

http://localhost/xdebug.php 测试下是否正常显示。

 

B、使用vim打开php文件

使用vim普通模式打开php文件，移动鼠标箭头到欲调试的那行，输入：

$:Bp

截图如下：



然后，按下F5(Mac:Fn+F5)，开始监听调试事件，这时在编辑窗底部提示5秒内访问要调试的php文件，例如：

http://localhost/xdebug.php? XDEBUG_SESSION_START=1

 

截图如下：



对于调试中的操作在下面附加上：

类型

功能

说明

<Command Mode>

 

 

:Bp

 toggle breakpoint

断点标记

:Up

 stack up

 

:DN

 stack down

 

<Normal Mode>

 

 

,e

 eval

 

<Function Keys>

 

 

F1

 resize

调整窗口大小

F2

 step into

调试步进入

F3

 step over

调试步进入下一标记

F4

 step out

调试步出当前标记

F5

 run

调试运行

F6

 quit debugging

退出调试模式

F11

 get all context

获得所有变量内容

F12

 get property of cursor

获得当前光标变量

 

 

三、跟踪分析

1、代码覆盖分析

Xdebug 2.2开始支持对代码覆盖的分析，也就是通过对代码的覆盖分析，我们可以了解到在IDE访问期间，有哪些代码行数被执行了，有助于对核心代码和单元测试有针对性的了解和分析，最终提高代码的质量。

A、涉及的配置

xdebug.coverage_enable=1

//该配置默认为1，也就是默认开启，如果设置为0，代码的覆盖分析就不会进行。

 

B、涉及的函数

boolean xdebug_code_coverage_started()

//该函数返回布尔值，用来判断代码覆盖分析功能是否开启，未开启则返回false。

 

void xdebug_start_code_coverage( [int options] )

//该函数没有任何返回，它的作用是开始搜集分析结果集数据，数据是以二维数组形势//存在，一维参数为分析的文件名字，二维参数为对应的分析行数；另外，在分析文件

//的每行代码时，都会产生一个结果码，如下：

//1：代表代码已经执行；

//-1：代表代码未被执行，对应函数参数XDEBUG_CC_UNUSED传入；

//-2：代表没有可执行的代码存在，对应XDEBUG_CC_DEAD_CODE和XDEBUG_CC_UNUSED

 

NOTE:

XDEBUG_CC_UNUSED：用来计算分析时包含搜集未被执行的代码；

XDEBUG_CC_DEAD_CODE：用来计算分析时代码行是否被执行；

 

形式如下：

xdebug_start_code_coverage(XDEBUG_CC_UNUSED|XDEBUG_CC_DEAD_CODE);

 

array xdebug_get_code_coverage()

//该函数返回数组值，用来搜集和返回代码覆盖分析的结果集信息。

 

void xdebug_stop_code_coverage( [int cleanup=true] )

//该函数不返回任何值，用来停止覆盖分析，如果传入参数为true，那么就会停止分析并清空内存中的分析结果集，否者传入false，反之，还可使用//xdebug_start_code_coverage找回该内存信息。

 

C、示例的验证

Php代码：

<?php

echo '覆盖分析进行中...</br>';

 

// 构建封装对象

class XdebugCoverageAnalysisModel {

      private $_coverage_info;

      private $_status;

 

      function __construct() {

          $this->_coverage_info = xdebug_get_code_coverage();

          $this->_status =xdebug_code_coverage_started();

        }

 

      // 获取分析结果

      public functiongetCodeCoverageResult() {

           returnjson_encode(xdebug_get_code_coverage());

      }

 

      // 开启覆盖分析

      public functionxdebugStartCodeCoverage() {

            xdebug_start_code_coverage( -1 | -2 );

        }

 

      // 分析是否执行

      public functionxdebugCodeStarted() {

           return xdebug_code_coverage_started();

      }

}

 

// 初始化

$apiModel = new XdebugCoverageAnalysisModel();

 

echo '开启覆盖分析...</br>';

$apiModel->xdebugStartCodeCoverage();

 

// 定义一个测试函数

function coverageSample($a,$b) {

   echo '函数结果：'.($a * $b).'</br>';

}

 

echo '判断是否开启...</br>';

$status = $apiModel->xdebugCodeStarted();

if($status=='1') {

  echo '开启覆盖分析已完成</br>';

} else {

  echo '开启覆盖分析失败了</br>';

}

 

echo '测试函数开启...</br>';

coverageSample(10,10);

 

echo '获取分析结果...</br>';

$result = $apiModel->getCodeCoverageResult();

echo $result.'</br>';

 

echo '关闭分析开关...</br>';

xdebug_stop_code_coverage();

 

$status = $apiModel->xdebugCodeStarted();

if($status=='1') {

  echo '覆盖分析已经完成</br>';

} else {

  echo '覆盖分析已经关闭！</br>';

}

 

unset($result);

unset($apiModel);

 

?>

 

浏览器结果：



 

2、PHP脚本分析

Xdebug的PHP脚本分析功能比较实用，它可以帮助我们分析代码的瓶颈和影响性能缓慢的问题，为优化代码提供可行性的参考。

 

A、涉及的配置

xdebug.profiler_enable

//该配置默认为0，为开启，设置为非0之后，即开启profiler功能

xdebug.profiler_output_dir

//该配置为上面开启之后，存放生成分析文件的位置，需要保证位置可写入，默认/tmp

xdebug.profiler_enable_trigger

//如果开启该选项，则在每次请求中如果GET/POST或cookie中包含//XDEBUG_PROFILE变量名，则才会生成性能报告文件(前提是必须关闭

//xdebug.profiler_enable选项，否则该选项不起作用)。

xdebug.profiler_output_name

//可以使用该配置修改生成的分析文件，默认cachegrind.out.%p

 

NOTE:

建议使用xdebug.profiler_enable_trigger替代xdebug.profiler_enable。

 

B、涉及的函数

string xdebug_get_profiler_filename()

//返回类型为字符串，用来返回分析的文件名字

 

C、示例的验证

当我们开启分析开关之后，当有脚本运行就会在指定的位置生成格式为cachegrind.out.xxx的分析文件：



该文件的内容不是很直观，所以需要使用可视化的工具来查看和分析，而Xdebug本身就支持使用第三方的可视化profiler文件的内容。在Linux下，可以使用KCacheGrind，而在Windows平台，可以使用QCacheGrind，当然还有一些在线的由爱好者开发的工具，例如：WebGrind，具体怎样使用这些工具，可以参考：

https://xdebug.org/docs/profiler

下面罗列下，WebGrind的效果：



 

WebGrind可以在这里下载：

https://github.com/jokkedk/webgrind

 

四、注意事项

1、避免生产环境开启profiler和trace，只需开启远程调试；

2、尽量使用xdebug.profiler_enable_trigger替代xdebug.profiler_enable；

3、如果使用webgrind分析profiler，建议不要放入生产环境，因为其没有安全限制，任何人都可以访问；

4、Xdebug的功能虽然强大，但是要均衡性能开销；

 

五、遇到问题

问题：Error("DbgProtocol instance has no attribute 'stop'",)

产生该问题的原因大致如下：

A、配置文件配置不正确；

B、.vimrc和php.ini中的port不相同；

C、.vimrc和php.ini中的port与现有的port冲突；

解决：

对照上面的几条仔细查看配置即可。

 

NOTE:

有博客说因为未在URL后添加XDEBUG_SESSION_START=1，其实不然。

 

 

 

技术讨论群：489451956（新）
————————————————
版权声明：本文为CSDN博主「云水之路」的原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/why_2012_gogo/article/details/51170609