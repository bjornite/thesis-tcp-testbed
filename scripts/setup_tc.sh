#!/usr/bin/env bash
sudo tc qdisc del dev eth0 root
ethtool -K eth0 gso off gro off tso off
sudo sysctl -w net.ipv4.tcp_no_metrics_save=1
modprobe ifb
ip link set dev ifb0 up
ethtool -K ifb0 gso off gro off tso off
tc qdisc add dev eth0 ingress
tc filter add dev eth0 parent ffff: protocol ip u32 match u32 0 0 flowid 1:1 action mirred egress redirect dev ifb0

