# Traffic dump

TCP dump linux automation script with monitoring.

1) copy dump_mngr.sh to the hosts

2) create config directory. Search path is:
- /etc/dump.conf.d
- ~/dump.conf.d
- sctipt location's subdirectory dump.conf.d

Create config file per tcp dump process (with name *.conf).

Example `mgcp.conf`:
```
INTERFACE=any
FILTER="host 10.10.100.44"
PARAMS="-s0 -n -C 10000000 -W 100 -Z root"
DUMP_DIR=/tmp
DUMP_FILE_PREFIX=`hostname`_mgcp.rtp.3.2
```

