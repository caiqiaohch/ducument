# [Erlang --- sasl错误日志]

erlang应用都会启动一个sasl应用，sasl的一个重要功能便是可以记录系统进程相关日志，如进程启动、结束、崩溃错误等信息。sasl的日志功能是基于erlang自带的日志模块error_logger来实现的，sasl中定义了下面3个错误处理：

sasl_report_tty_h:将日志输出到控制台

sasl_report_file_h:将日志输出到单个文件

error_logger_mf_h:循环日志文件记录

sasl日志配置解析示例文件elog.config

[{sasl, [ 
     %% minimise shell error logging 
     {sasl_error_logger, false}, 
     %% only report errors 
     {errlog_type, error}, 
     %% define the parameters of the rotating log 
     %% the log file directory 
     {error_logger_mf_dir,"./logs"}, 
     %% # bytes per logfile 
     {error_logger_mf_maxbytes,10485760}, % 10 MB 
     %% maximum number of 
     {error_logger_mf_maxfiles, 10} 

​    ]}]. 

上面的配置实际上可以分为两组
1).输出到控制台或者单个文件sasl_error_logger 、errlog_type，这组配置对sasl_report_tty_h、sasl_report_file_h这两个日志处理器有效

sasl_error_logger false|tty|{file,File}|{file, FileName, Modes}  默认tty

errlog_type error|progress|all， 默认all

2).输出到循环日志文件
error_logger_mf_dir 日志目录
error_logger_mf_maxbytes 日志文件大小

error_logger_mf_maxfiles 日志文件个数

上面两组配置是互相独立的，启动erlang时可以指定配置文件

$erl -boot start_sasl -config elog

start_sasl是一个启动文件，在erlang的安装目录下可以找到，全称为start_sasl.boot, elog就是上面的配置文件elog.config。

读取循环日志
循环日志是用二进制格式记录在文件中的，需要使用rb工具读取，rb常用函数有：
rb:start(Options) 启动rb
{max, MaxNoOfReports} 读取的最大日志条数
{report_dir, DirString} 指定读取日志的目录，默认为配置项error_logger_mf_dir中的值
{type, ReportType} 读取指定类型的报告，error | error_report | info_msg | info_report | warning_msg | warning_report | crash_report | supervisor_report | progress
rb:stop() 停止rb
rescan(Options) 重新扫描日志文件
list()、list(Type) 列出所有的日志报告，Type可以指定列出的报告类型

show(Report) 显示日志报告的详细信息，Report取值为list列出的编号。