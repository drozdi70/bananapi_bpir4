#!/bin/bash

STATUS_UP=UP

cd /nvme/work/oled
rm ./info2.log
echo "LAN: `ifconfig br-lan |grep "inet " |awk '{print $2}'`" > info2.log
echo "WAN: `uci get network.FM350GLPCI.ipaddr`" >> info2.log
SSID=`iwinfo  |grep "ESSID" | awk '{print $3}'`
UPDOWN=`iwinfo  |grep "Access Point" | awk '{print $3}' |wc -l`
if [[ "$UPDOWN" -gt "0" ]] 
	then STATUS=UP
	else STATUS=DOWN
fi
echo "WIFI: $SSID $STATUS" >> info2.log
sed -i 's/addr://g' ./info2.log
