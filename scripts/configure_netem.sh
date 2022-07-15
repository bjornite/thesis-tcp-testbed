#!/usr/bin/env bash
while getopts d:r: flag
do
    case "${flag}" in
        d) DELAY_MS=${OPTARG};;
        r) RATE_MBIT=${OPTARG};;
        *) echo "Invalid parameter"
    esac
done

tc qdisc add dev ifb0 handle 1: root htb default 11
tc class add dev ifb0 parent 1: classid 1:1 htb rate ${RATE_MBIT}mbit ceil ${RATE_MBIT}mbit
tc class add dev ifb0 parent 1:1 classid 1:11 htb rate ${RATE_MBIT}mbit ceil ${RATE_MBIT}mbit
tc qdisc add dev ifb0 parent 1:11 codel ecn
