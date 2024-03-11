#!/bin/bash

#Preparing file with value to displayed on OLED
cd /nvme/work/oled
./info.sh 

#Send data to OLED
./oled128x64 /dev/i2c-1
sleep 30
rm info2.log
#Clear OLED display
./oled128x64 /dev/i2c-1
