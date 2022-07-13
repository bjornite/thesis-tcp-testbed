#!/usr/bin/env bash

server=100.119.51.82
client=100.106.5.126

delay=40
maxrate=60
RATES=(2 3)
DELAYS=(25 50 75 100)

for r in "${RATES[@]}"; do
    rate=`expr $maxrate / $r`
    for delay in "${DELAYS[@]}"; do
        echo "Running with delay=$delay ms and rate=$rate Mbit/s"
        #echo "Configuring server..."
        ssh root@$server "./update_netem.sh -d $delay -r $maxrate; echo server configured! & exit"
        #echo "Starting Flent"
        ssh root@$client screen -d -m "flent tcp_1up -p all_scaled -l 60 -H 192.168.1.176 -t netem_cubic_${delay// /}msdelay_r${r// /}_ecn3 --socket-stats " &
        sleep 30s
        #echo "Configuring server..."
        ssh root@$server "./update_netem.sh -d $delay -r $rate; echo server configured! & exit"
        sleep 45s
    done
done