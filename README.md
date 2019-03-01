# traffic_dump

TCP dump linux  service

1) copy dump_mngr.sh to the hosts

2) create config directory `~/dump.conf.d/` and config file per tcp dump process (with name *.conf).

Example:
```
INTERFACE=any
FILTER="host 10.10.100.44"
PARAMS="-s0 -n -C 10000000 -W 100 -Z root"
DUMP_DIR=/tmp
DUMP_FILE_PREFIX=`hostname`_mgcp.rtp.3.2
```

4) add dump_mngr.sh monitor to cron to ensure service is running


