#!/bin/bash
#echo $1 >> /tmp/capture.log

HOST=`echo $1 | awk -F"://" '{print $2}' | cut -d/ -f1`
PORT=`echo $1 | awk -F"://" '{print $2}' | cut -d/ -f2 | sed 's/vunl_/vunl0_/'`

echo "Capturing on: Host: $HOST  -   Port: $PORT"  >> /tmp/capture.log

xterm -e "wireshark -k -i <(ssh -l root $HOST tcpdump -s 0 -U -n -v -w - -i $PORT)"
