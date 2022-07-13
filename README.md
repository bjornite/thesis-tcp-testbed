# Analyzing a Theoretically Optimal Capacity-Seeking Congestion Controller

This document explains how to run the experiments described in our paper "Analyzing a Theoretically Optimal Capacity-Seeking Congestion Controller".

## Setting up the testbed

Materials:

* 2 Raspberry Pi 4B machines with memory cards and power supplies
* A router or switch with Gigabit ethernet
* A laptop to configure the Raspberry Pis and control the experiments

The README.md file in the nixos-files folder explains how to install the OS and necessary software on the Raspberry Pis.

Connect both Pis to the router/switch using gigabit ethernet.

## Configuring the experiments

Before running each experiment, both the client and the server must be configured correctly

### Configure the client

1. Select the TCP congestion control algorithm you want to use:
```
[root@client:~]# cat /proc/sys/net/ipv4/tcp_available_congestion_control
reno cubic bbr highspeed hybla illinois nv scalable westwood vegas yeah
[root@client:~]# sysctl -w net.ipv4.tcp_congestion_control=bbr
net.ipv4.tcp_congestion_control = bbr
```

2. Set the ECN policy. Use 3 for DCTCP and BBR, and 1 for Cubic.

```
[root@client:~]# sysctl net.ipv4.tcp_ecn
net.ipv4.tcp_ecn = 1

[root@client:~]# sysctl -w net.ipv4.tcp_ecn=1
net.ipv4.tcp_ecn = 1
```

### Configure the server

1. The scripts *setup_tc.sh* and *configure_netem.sh* must be executed on the server before the experiments are started. These set up htb and codel qdiscs on the ingress of eth0 on the server, and a netem on the egress of eth0. The testbed setup will look something like this:


![Testbed](testbed(1).png)


2. The script *update_netem.sh* must be copied to the servers root folder.
3. Set the correct TCP congestion control on the server as well (DCTCP must be configured on both ends for correct operation)
4. Set the ECN policy on the server. Use 3 for DCTCP and BBR, and 1 for Cubic.

## Run the experiments

Finally, the script *run_experiments.sh* will start the flent session on the client and also takes care of configuring netem on the server to reduce the rate at the right time. The script must be updated with the correct IP Adresses to run correctly.

## Results

The raw data from Flent used for the paper can be found in the folders *bbr*, *dctcp* and *cubic*.

## Details

Router version:

```
root@OpenWrt:~# ubus call system board
{
	"kernel": "5.4.154",
	"hostname": "OpenWrt",
	"system": "MediaTek MT7621 ver:1 eco:3",
	"model": "UniElec U7621-06 (16M flash)",
	"board_name": "unielec,u7621-06-16m",
	"release": {
		"distribution": "OpenWrt",
		"version": "21.02.1",
		"revision": "r16325-88151b8303",
		"target": "ramips/mt7621",
		"description": "OpenWrt 21.02.1 r16325-88151b8303"
	}
}
```