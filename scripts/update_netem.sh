#!/usr/bin/env bash
while getopts d:r: flag
do
    case "${flag}" in
        d) DELAY_MS=${OPTARG};;
        r) RATE_MBIT=${OPTARG};;
        *) echo "Invalid parameter"
    esac
done

tc qdisc replace dev eth0 root netem delay ${DELAY_MS}ms
tc class change dev ifb0 parent 1: classid 1:1 htb rate ${RATE_MBIT}mbit ceil ${RATE_MBIT}mbit
tc class change dev ifb0 parent 1:1 classid 1:11 htb rate ${RATE_MBIT}mbit ceil ${RATE_MBIT}mbit

