vagrant-foreman1.5
==================

Vagrant script to create a foreman 1.5 VM


Configuration Note
==================
After the Foreman is up and running, during the very first interface access, please do this following:

1. From the top menu bar, Host -> Provisioning Templates
2. Jump to page 2, then select "PXELinux global default"
3. At the very bottom add these lines:
<pre>
LABEL discovery
MENU LABEL Foreman Discovery
MENU DEFAULT
KERNEL /boot/vmlinuz0
APPEND initrd=/boot/initrd0.img foreman.url=https://foreman.cloudcomplab.ch root=live:/foreman.iso
IPAPPEND 2
</pre>
4. Change 'ONTIMEOUT local' -> 'ONTIMEOUT discovery' on line 13
5. Save the changes
6. From the top menu bar, Infrastructure -> Provisioning setup
7. Go through the steps, providing all known values as much as possible
8. For the subnet, choose the foreman machine IP as the gateway for the subnet
9. NOTE: THERE IS NO NEED TO EXECUTE THE FOREMAN INSTALL COMMAND SUGGESTED IN STEP 3, just click next
10. Just choose the Operating System setup option suggested by the system, just select the 'Ubuntu mirror' as the media source and choose next.

That is all. Your foreman is all configured to do host discovery and provisioning.
