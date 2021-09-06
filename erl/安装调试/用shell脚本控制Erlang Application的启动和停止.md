# 用shell脚本控制Erlang Application的启动和停止

一般就用下面两个参数
./server.sh init
./server.sh shutdown

shell脚本我不是很熟，看看各位有没有改进的地方 
#!/bin/sh
##
## usage server.sh {init|start|stop|shutdown}
## First run,use init,create NODE
##
ERL=/usr/local/erlang/bin/erl
PA=/game/game_chat_server
export HEART_COMMAND="$PA/server.sh start"
case $1 in
  init)
    echo  "Init Starting Server..."
    $ERL -boot game_server-1 -config sasl -sname chatserver01 \
         -detached                                    
    ;;

  start)
    echo "Starting Server..."
    $ERL -noshell -sname manage \
           -eval 'server_manage:start("chatserver01@NBCTC-5-160","game_chat_server")' \
           -s init stop
    ;;
  stop)
    echo "Stopping Server..."
    $ERL -noshell  -sname manage \
           -eval 'server_manage:stop("chatserver01@NBCTC-5-160","game_chat_server")' \
           -s init stop
    ;;

  shutdown)
    echo "Shutdown Server..."
    $ERL -noshell -sname manage \
           -eval 'server_manage:shutdown("chatserver01@NBCTC-5-160","game_chat_server")' \
           -s init stop
    ;;
  *)
    echo "Usage: $0 {init|start|stop|shutdown}"
    exit 1
esac

exit 0
发现命令行 -s MODDULE Fun arg 这样的方式不好使，就改成 -eval的了
server_manage.erl 代码：
-module(server_manage).
-export([start/2,stop/2,shutdown/2]).

start(Node,Service) ->
    rpc:call(list_to_atom(Node),application,start,[list_to_atom(Service)]),
    io:format("~p:~p ok~n",[Node,Service]).
stop(Node,Service)  ->
    rpc:call(list_to_atom(Node),application,stop,[list_to_atom(Service)]),
    io:format("~p:~p ok~n",[Node,Service]).
shutdown(Node,Service)  ->
    rpc:call(list_to_atom(Node),application,stop,[list_to_atom(Service)]),
    rpc:call(list_to_atom(Node),init,stop,[]),
    io:format("~p:~p ok~n",[Node,Service]).
————————————————
版权声明：本文为CSDN博主「iteye_10738」的原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/iteye_10738/article/details/82435497