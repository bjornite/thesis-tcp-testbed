{ config, pkgs, ... }:

{
  services.chrony = {
    enable = true;
    extraConfig =
     ''
     pool ntp.ubuntu.com        iburst maxsources 4
     pool 0.ubuntu.pool.ntp.org iburst maxsources 1
     pool 1.ubuntu.pool.ntp.org iburst maxsources 1      
     pool 2.ubuntu.pool.ntp.org iburst maxsources 2
     keyfile /etc/chrony/chrony.keys
     driftfile /var/lib/chrony/chrony.drift
     logdir /var/log/chrony
     maxupdateskew 100.0
     rtcsync
     makestep 1 3
     local stratum 10
     allow 192.168.0.0/16
     ''; 
  };
}
