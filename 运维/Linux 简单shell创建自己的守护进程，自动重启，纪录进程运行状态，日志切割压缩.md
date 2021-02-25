Linux 简单shell创建自己的守护进程，自动重启，纪录进程运行状态，日志切割压缩

对于守护进程管理、自动重启、记录log，有一个很好用的进程管理工具 supervisord 。它可以说简单易用，且功能强大。但是对于我的部署需求来说还是过于繁琐，且没有搞定用它如何记录进程状态。

今天写了一个简单的shell脚本，以满足我的所有需求，并且部署简单。

希望能够给有同样需求的码农们提供一个参考。



pgmctl.sh



    #!/bin/bash
    #run:  /pathto/pgmctl.sh [start &|stop|restart &]
     
    #author: color_wind
     
     
    # shell dir name
    PAT=`dirname $0`
     
     
    # set parameters 
    CMD="$PAT/pgmctl"
    LOG="$PAT/logs/pgmctl.log"
    PID="$PAT/logs/.pgmctl.PID"
    CFG="$PAT/conf/px.cfg"
     
    #set ulimit
    ULM="102400"
     
    # ---------------------------------------------------
    # edit these function as your needs
    function start {
    	ulimit -n $ULM
    	$CMD -f $CFG >> $LOG 2>&1 &
    	tpid=$!
    	echo $tpid > $PID
    	echo "start [ok]"
    }
     
    function stop {
    	kill `cat $PID`
    	rm $PID
    	echo "stop [ok]"
    }
     
    # --------------------------------------------------
     
     
    echo "$CMD $1"
     
    case "$1" in
    start)
    	start
    ;;
    restart)
    	if [ -f $PID ] ; then
    		stop
    		sleep 3
    	fi
    	start
    ;;
    stop)
    	stop
    	exit 0
    ;;
    esac
     
    TMP_LOG_DAY=`date '+%y%m%d'`
     
    for (( c=0 ; ; c++ ))
    do
    	TMP_LOG_NOW=`date '+%y%m%d' -d '+5 second'`
    	if (($TMP_LOG_DAY != $TMP_LOG_NOW)); then
    		cp -f $LOG $LOG".1"
    		echo " " > $LOG
    		gzip -c $LOG".1" > $LOG"."$TMP_LOG_DAY".gz" &
    		TMP_LOG_DAY=$TMP_LOG_NOW
    	fi
     
    	if [ -f $PID ] ; then
    		tpid=`cat $PID`
    		cmdex="ps uh -p$tpid"
    		psrtn=`$cmdex`
    		if [ -z "$psrtn" ]; then
    			echo "`date '+%y%m%d%H%M%S'` FATALERROR RESTART SERVICE" >> $LOG
    			start
    		elif (( $c%20 == 0 )); then
    			echo "`date '+%y%m%d%H%M%S'` PSINFO: $psrtn" >> $LOG 
    			c=0
    		fi
    		sleep 3 
    	else
    		break
    	fi
    done
 
 
 
 


启动：./pgmctl.sh  start  &
重启：./pgmctl.sh restart &

停止：./pgmctl.sh stop



另外，此脚本只是示例，提供一个思路。到你正在用的时候，需要按照自己需求修改
 ———————————————— 
版权声明：本文为CSDN博主「color_wind」的原创文章，遵循CC 4.0 by-sa版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/color_wind/article/details/37908035