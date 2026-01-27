#!/bin/bash
# SPDX-License-Identifier: BSD-3-Clause
# Copyright 2024 NXP
####################################################################
#set -x

print_usage()
{
echo "usage: iq-start-app-tx.sh"
}

# check parameters
if [ $# -ne 0 ];then
        echo Arguments wrong.
        print_usage
        exit 1
fi

# check la9310 shiva driver and retrieve iqsample info i.e. iqflood in scratch buffer (non cacheable)

ddrh=`la9310_modem_info | grep FLOOD |cut -f 2 -d "|" |sed 's/	//g'|sed 's/ //g'`
maxsize=`la9310_modem_info | grep FLOOD |cut -f 4 -d "|" |sed 's/	//g'|sed 's/ //g'`
if [[ "$ddrh" -eq "" ]];then
        echo can not retrieve IQFLOOD region, is LA9310 shiva started ?
        exit 1
fi
if [ 32768 -gt $[$maxsize/2] ];then
        echo fifo too large to fit in IQFLOOD region $maxsize bytes
        exit 1
fi

# use first half of iqflood region, 32KB fifo in first 1M, then source file for the app. 

bin2mem -f ./tone_td_3p072Mhz_20ms_4KB1200_2c.bin -a $[$ddrh + 0x00100000]
taskset 0x8 iq_app -t -a 0x00100000 4915200 -f 0x00000000 32768 &
./iq-start-txfifo.sh 8
