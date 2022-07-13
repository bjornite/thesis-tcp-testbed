# thesis-tcp-testbed

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
Configure ssh to use the correct ssh key
```

bjorn@bjorn-ThinkPad-E14:~$ sudo cat /root/.ssh/config
[sudo] password for bjorn: 
Host server
	HostName 192.168.1.176
	Port 22
	User root

	# any other fancy option needed to log in
	# ProxyJump foo ...

	# Prevent using ssh-agent or another keyfile, useful for testing
	IdentitiesOnly yes
	IdentityFile /root/.ssh/nix_remote
	
Host client
	HostName 192.168.1.249
	Port 22
	User root

	# any other fancy option needed to log in
	# ProxyJump foo ...

	# Prevent using ssh-agent or another keyfile, useful for testing
	IdentitiesOnly yes
	IdentityFile /root/.ssh/nix_remote

```
If you have more than one nixops deployment, select the right one by setting the environment variable
```
bjorn@bjorn-ThinkPad-E14:~$ nixops list
+--------------------------------------+------------+--------------+------------+------+
| UUID                                 | Name       | Description  | # Machines | Type |
+--------------------------------------+------------+--------------+------------+------+
| 8fa4965c-f207-11ec-bb76-f875a46b3e4a | TCPtestbed | TCP testbed  |          2 | none |
| 0168c4e3-25ed-11ec-a898-f875a46b3e4a | testbed    | WiFi testbed |          9 | none |
+--------------------------------------+------------+--------------+------------+------+
bjorn@bjorn-ThinkPad-E14:~$ export NIXOPS_DEPLOYMENT=8fa4965c-f207-11ec-bb76-f875a46b3e4a

```
Finally, build and deploy:

```
bjorn@bjorn-ThinkPad-E14:~$ nixops deploy
```

## Commands for configuring experiments

Setting congestion control algorithm

```
[root@client:~]# cat /proc/sys/net/ipv4/tcp_available_congestion_control
reno cubic bbr highspeed hybla illinois nv scalable westwood vegas yeah
[root@client:~]# sysctl -w net.ipv4.tcp_congestion_control=bbr
net.ipv4.tcp_congestion_control = bbr
```

Setting ECN configuration
```
[root@server:~]# sysctl  net.ipv4.tcp_ecn
net.ipv4.tcp_ecn = 3
```

The scripts *setup_tc.sh* and *configure_netem.sh* must be executed on the server before the experiments are started.
These set up a netem qdisc on the ingress of eth0 on the server. The experiment configuration will look something like this:

Client --(netem delay and rate limit)--> Server --> Client

Finally, the script *run_experiments.sh* will start the flent session on the client and also takes care of configuring netem on the server to reduce the rate at the right time.