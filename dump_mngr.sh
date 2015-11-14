#!/usr/bin/env bash
#set -x
action=$1
rc=0

PID_DIR=/var/run
DUMP_BIN=/usr/sbin/tcpdump
CONF_DIR=/root/traffic_dump/conf.d

case $action in
"start")
  if [ -d "$CONF_DIR" ]; then
    for file in `find  "$CONF_DIR"  -type f -name 'dump.*'`; do
      NAME=`basename $file`
      INTERFACE=any
      FILTER="tcp port 80"
      PARAMS="-q -s0"
      DUMP_DIR=/var/dump
      DUMP_FILE_PREFIX=dump
      source $file
            
      pidfile="$PID_DIR"/dumpcap_$NAME.pid

      if [ -f "$pidfile" ];then
         pid=`cat "$pidfile"`
           if [ -d /proc/$pid ];then
              echo "dumpcap $NAME already running with pid $pid"
           else
              echo "dumpcap $NAME with pid $pid crashed, clean up pid file $pidfile manually and try again"
           fi
      else
           if [ "$INTERFACE" != "" ];then
  	         nohup $DUMP_BIN -i $INTERFACE $PARAMS -w $DUMP_DIR/$DUMP_FILE_PREFIX  $FILTER  > /dev/null 2>&1 &
             pid=$!
             echo $pid > "$pidfile"
             echo "Started dumpcap $NAME with pid $pid"
           else
             echo "Parameter INTERFACE cannot be empty"
           fi
     fi
     
     done
  else
    echo "missing configuration $CONF_DIR"
  fi
  ;;
"stop")
  for file in `find "$PID_DIR" -type f -name 'dumpcap_*.pid'`;do
    if [ -f "$file" ];then
      pid=`cat $file`
      if [ -d /proc/$pid ];then
        echo "Stopped dumpcap with pid $pid"
        kill -9 $pid
      else
        echo "Cleaning up pidfile $pidfile";
      fi
      rm -f "$file"
    else
      echo "dumpcap not running"
    fi
  done
  ;;
"monitor")
  for file in `find "$PID_DIR" -type f -name 'dumpcap_*.pid'`;do
    if [ -f "$file" ];then
      pid=`cat $file`
      if [ -d /proc/$pid ];then
        echo "dumpcap running with pid $pid"
      else
        echo "dumpcap pid $pid crashed, restarting"
        rm -f "$file"
        $0 start
      fi
    else
      echo "dumpcap on not running"
    fi
  done
  ;;
*)
  echo "usage $0 start|stop|monitor"
esac
exit $rc

