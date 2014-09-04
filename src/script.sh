#!/bin/bash
cat > /etc/hostname << EOF
foreman
EOF

cat >> /etc/hosts << EOF
127.0.0.1	localhost
127.0.1.1	foreman.cloudcomplab.ch	foreman
EOF

apt-get update
apt-get upgrade -y
echo "deb http://deb.theforeman.org/ trusty 1.5" > /etc/apt/sources.list.d/foreman.list
echo "deb http://deb.theforeman.org/ plugins 1.5" >> /etc/apt/sources.list.d/foreman.list
wget -q http://deb.theforeman.org/pubkey.gpg -O- | apt-key add -
apt-get update
apt-get install -y foreman-installer
rm /etc/foreman/foreman-installer-answers.yaml
cp /tmp/files-to-go/foreman-installer-answers.yaml /etc/foreman/foreman-installer-answers.yaml
foreman-installer
# copy the discovery template in correct folder
cp /tmp/files-to-go/default /var/lib/tftpboot/pxelinux.cfg/
cd /tmp/
echo "Downloading discovery images and linux netboot files. Please be patient ..."
wget --quiet http://downloads.theforeman.org/discovery/releases/latest/foreman-discovery-image-3.0.5-20140523.0.el6.iso-vmlinuz
wget --quiet http://downloads.theforeman.org/discovery/releases/0.5/foreman-discovery-image-3.0.5-20140523.0.el6.iso-img
mv /tmp/foreman-discovery-image-3.0.5-20140523.0.el6.iso-vmlinuz /var/lib/tftpboot/boot/vmlinuz0
mv /tmp/foreman-discovery-image-3.0.5-20140523.0.el6.iso-img /var/lib/tftpboot/boot/initrd0.img
echo "Now downloading the ubuntu images ..."
wget --timeout=10 --tries=3 --quiet --no-check-certificate -nv -c "http://archive.ubuntu.com/ubuntu//dists/trusty/main/installer-amd64/current/images/netboot/ubuntu-installer/amd64/initrd.gz" -O "/var/lib/tftpboot/boot/Ubuntu-12.04-x86_64-initrd.gz"
wget --timeout=10 --tries=3 --quiet --no-check-certificate -nv -c "http://archive.ubuntu.com/ubuntu//dists/trusty/main/installer-amd64/current/images/netboot/ubuntu-installer/amd64/linux" -O "/var/lib/tftpboot/boot/Ubuntu-12.04-x86_64-linux"
/sbin/iptables --table nat --append POSTROUTING --out-interface eth0 -j MASQUERADE
/sbin/iptables --append FORWARD --in-interface eth1 -j ACCEPT
sysctl net.ipv4.ip_forward=1
sysctl -p

echo "Setting the Net forwarding rules now."
cp /tmp/files-to-go/fwd-traffic /etc/init.d/fwd-traff
chmod a+x /etc/init.d/fwd-traff
#set to run on boot
ln -s /etc/init.d/fwd-traff /etc/rc2.d/S96forwardtraffic

# install the rules
/etc/init.d/fwd-traff

echo "Rebooting machine ... please wait a few seconds before doing vagrant ssh"
reboot
