#!/bin/bash 

directory='output4'
baddr='00:06:66:A0:3B:7C'
sudo rfcomm release -a
sudo rfcomm bind 0 $baddr 

SHIMMER_ADDR=''
CC2540_ADDR=''

if [ $# -eq 0 ]
  then
  	echo "invalid names"
  	exit
fi

if [ $# -eq 1 ]
  then
    SHIMMER_ADDR=./$directory/shimmer_$1
    CC2540_ADDR=./$directory/2540_$1
fi

if [ $# -eq 2 ]
  then
    SHIMMER_ADDR=./$directory/shimmer_$1
    CC2540_ADDR=./$directory/2540_$2
fi

sudo python visualizer_shimmer.py $baddr >> $SHIMMER_ADDR &
sudo python visualizer.py /dev/ttyACM0 >> $CC2540_ADDR &
