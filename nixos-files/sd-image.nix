{ ... }: {
  imports = [
    <nixpkgs/nixos/modules/installer/sd-card/sd-image-aarch64.nix>
  ];
  services.openssh = {
   enable = true;
   permitRootLogin = "yes";
  };
  # put your own configuration here, for example ssh keys:
  users.users.root.openssh.authorizedKeys.keys = [
     "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDLoRiFchJRetN79N9aKyHnkYSJRoMdUgXoz0oo1yVabLvDjwUUeXLr+ch6ySrE9e4A1+E3pVHpidbHdP0NcBEXi6sSz2FBPw8hBOVkpwZ5/cwKHLRIBcIPDumpp7P0ZfqUnyXrPR0L4aZBHobPZ0LG7iEU8WMDj4TX13ZKexDFESe2MHejMOh1iBWXgc/Y04ptlSnuNtitY9zZdO95EMKGx+et4NiVia+5KZvIgT7/xZfEiE4Skhqrohb9FnmLW+kr4J+O7LRKENKT+tpULqsGnm+zREQVhIqoCyjJESbX8S57N0UdtshCrWGm1RvGCv+RRE9XNi3Ahd9xtYUK4b7R bjorn@bjorn-ThinkPad-E14"
     "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDMW/AJqDvFDmGo5z7ppXlrfSXcmxJ7JxEq7jMy6y7jf3Xfa/79Z5t1bTpQIYisVEdlsOS5KHd34PDSEiRHk3lZsaRM77yuSMVwD0HuyuDklRks5JAK3bL3vM2xQIprgrMuZxYnFleZKy2VETPbdSVQ9TftkLqHNYRsxnq2WCyK/zs6GopKhFJ49aAlgdzpi7q6nO3rwdUDf0kpYDe250XBGw4SQCWGjqkUOYFbu8a9mmcOi2dweCPs7nsFh/ZSBMV4OinMo6cUl0sOZ3zJPCFWANSt5brtpV2eA9FLcvBxLEhcOvaUc/WuXkgQgEnwRHX1vxGDnU19HcaZ/CGfs+eQLtRwYKNs5tBs4P0IjP/8R3goaPw0ryY/uubURMK05JzMUmRIT4/SnbfdPqQg1VaIXsN2oR2zOpv01Q1CU3fFgRP0zYr2G9FePKQeOaO7XpEukJ4EhfCpo1JR31P6CLYHTbra7I6dLNm/ggi5Dx11kEnkilVJSxWsiCF5Yok9pos= root@bjorn-ThinkPad-E14"
  ];

}

# Build with: nixos-generate -f sd-aarch64-installer --system aarch64-linux -c sd-image.nix
# Useful link: https://nixos.wiki/wiki/NixOS_on_ARM#Compiling_through_QEMU
# How to configure Linux to use a raspberry pi to build aarch64 images: https://nixos.wiki/wiki/Distributed_build


#Snapshot of the config used for the thesis:

#bjorn@bjorn-ThinkPad-E14:~/DomosLabs/thesis-wifi-testbed/nixos-files$ cat ~/.ssh/config
#Host server
#	HostName 192.168.3.176
#	Port 22
#	User root
#
#	# any other fancy option needed to log in
#	# ProxyJump foo ...
#
#	# Prevent using ssh-agent or another keyfile, useful for testing
#	IdentitiesOnly yes
#	IdentityFile /home/bjorn/.ssh/id_rsa
#
#bjorn@bjorn-ThinkPad-E14:~/DomosLabs/thesis-wifi-testbed/nixos-files$ cat /etc/nix/nix.conf 
#
#build-users-group = nixbld
#builders = ssh://server aarch64-linux