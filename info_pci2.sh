#!/bin/bash
# lm-sensors package needed to be installed
cd /nvme/work/oled
rm ./info2.log
echo "WiFi temp: `sensors |grep -i temp1 | awk -F ' ' '{print $2}' | head -n 1`" > info2.log
echo "CPU temp:  `sensors |grep -i temp1 | awk -F ' ' '{print $2}' | tail -n 1`" >> info2.log
echo "NVMe temp: `sensors |grep -i Composite | awk -F ' ' '{print $2}' | head -n 1`" >> info2.log
sed -i 's/°//g' ./info2.log
