#!/bin/bash
#
# FM350-GL reconnection
#
# DroZDi 15.03.2024
#
cd /root
rm my_ip_status.txt
ping -c3 www.google.com > my_ip_status.txt
STATUS=`cat my_ip_status.txt |grep " 0% packet loss" |wc -l`
if [ $STATUS -eq 1 ]; then
        exit 0
fi
 > /etc/crontabs/root
/etc/init.d/cron enable
/etc/init.d/cron reload
#
# Installing driver usbserial_generic for FM350-GL
#
#echo "0e8d 7127" > /sys/bus/usb-serial/drivers/generic/new_id
# Installing driver optional for FM350-GL
#
echo "0e8d 7127 ff" > /sys/bus/usb-serial/drivers/option1/new_id
#
# Some time for SIM registration
#
#echo -e "AT+CFUN=1,1" > /dev/ttyUSB4
sms_tool -d /dev/ttyUSB4 at "AT+CFUN=1,1"
sleep 20
#
# Modem initilization and internet connection
#
#echo -e "AT+CGDCONT=1,\"IP\",\"internet\"" > /dev/ttyUSB4
#sleep 5
#echo -e "AT+CGACT=1,1" > /dev/ttyUSB4
#sleep 5
#
# Assigning ISP IP address to the FM350GL interface
#
#echo AT+CGPADDR=1 | socat - /dev/ttyUSB4,crnl > my_ip.txt
sms_tool -d /dev/ttyUSB4 at "AT+CGDCONT=1,\"IP\",\"internet\"" > my_ip2.txt
sleep 8
sms_tool -d /dev/ttyUSB4 at "AT+CGACT=1,1" >> my_ip2.txt
sleep 23
sms_tool -d /dev/ttyUSB4 at "AT+CGPADDR=1" > my_ip.txt
#fm350gl_ip_address=`cat my_ip.txt |grep -v OK |grep -v "AT+CGPADDR" |grep -v ^$ | tr -d '"' | grep "+CGPADDR" | awk -F ',' '{print $2}' | uniq`
fm350gl_ip_address=`cat my_ip.txt |grep -v "AT+CGPADDR" |grep -v ^$ | tr -d '"' | grep "+CGPADDR" | awk -F ',' '{print $2}' | tail -n 1`
uci set network.FM350GL.ipaddr="$fm350gl_ip_address"
uci commit network
service network reload
sleep 150
echo "* * * * * sleep 30; /root/fm350gl_reconnect.sh" >> /etc/crontabs/root
/etc/init.d/cron enable
/etc/init.d/cron reload
exit 0
