nmcli connection edit "DiS DataCenter"  
set ipv4.dns-search informantem.gen informantem.prt informantem.develop bravantic.qa bravantic.dm bravantic.prd
set ipv4.dns-priority 100
set ipv4.never-default yes
save
quit

nmcli connection modify "DiS DataCenter" ipv4.ignore-auto-dns yes

nmcli connection edit "RockIs\!Dead"
set ipv4.dns-search onemarc.io
set ipv4.dns-priority -1
set ipv4.never-default yes
save
quit

nmcli connection modify "RockIs\!Dead" ipv4.dns-routing true

-----------------

sudo dnf install systemd-resolved
sudo systemctl enable --now systemd-resolved
sudo ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf


sudo mkdir -p /etc/systemd/resolved.conf.d/
sudo nano /etc/systemd/resolved.conf.d/onemarc.conf


[Resolve]
DNS=192.168.8.10
Domains=~onemarc.io


sudo nano /etc/systemd/resolved.conf.d/informantem.gen.conf

[Resolve]
DNS=172.31.45.1
Domains=~informantem.gen ~informantem.prt ~informantem.develop ~bravantic.qa ~bravantic.dm ~bravantic.prd


sudo systemctl restart systemd-resolved
