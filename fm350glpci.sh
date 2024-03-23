#!/bin/sh
#
# FM350-GL modem initilization and config
#
# DroZDi 23.03.2024
#
> /etc/crontabs/root
cd /root
rm my_ip.txt
rm my_gate.txt
/bin/mount -a
/usr/sbin/i2cdetect -y -r 1
#
# Assigning ISP IP address to the FM350GL interface
#
mmcli -m 0 --set-allowed-modes='5g'
sleep 40
mmcli -m 0 --simple-connect="apn='internet'"
sleep 5
mmcli -b 1 |grep -i address > my_ip.txt
mmcli -b 1 |grep -i gateway > my_gate.txt

fm350gl_ip_address=`cat my_ip.txt |grep -v ^$ | awk -F ' ' '{print $3}' | tail -n 1`
fm350gl_ip_gate=`cat my_gate.txt |grep -v ^$ | awk -F ' ' '{print $3}' | tail -n 1`
uci set network.FM350GLPCI.ipaddr="$fm350gl_ip_address"
uci set network.FM350GLPCI.gateway="$fm350gl_ip_gate"
uci commit network
service network reload
exit 0
