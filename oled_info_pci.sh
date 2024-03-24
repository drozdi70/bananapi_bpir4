#!/bin/bash

#Preparing file with value to displayed on OLED
cd /nvme/work/oled
./info_pci.sh 

#Send data to OLED
./oled128x64 /dev/i2c-1
sleep 20
rm info2.log
#Send data sensors to OLED
./info_pci2.sh
./oled128x64 /dev/i2c-1
sleep 20
rm info2.log
#Clear OLED display
./oled128x64 /dev/i2c-1
