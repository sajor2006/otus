vgrename VolGroup00 OtusRoot
sed -i 's/VolGroup00/OtusRoot/g' /etc/fstab
sed -i 's/VolGroup00/OtusRoot/g' /etc/default/grub
sed -i 's/VolGroup00/OtusRoot/g' /boot/grub2/grub.cfg

mkinitrd -f -v /boot/initramfs-$(uname -r).img $(uname -r)
