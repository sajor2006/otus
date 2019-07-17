
mkdir /usr/lib/dracut/modules.d/01test
cat > /usr/lib/dracut/modules.d/01test/module-setup.sh <<EOF
#!/bin/bash

check() {
    return 0
}

depends() {
    return 0
}

install() {
    inst_hook cleanup 00 "/usr/lib/dracut/modules.d/01test/test.sh"
}
EOF


cat > /usr/lib/dracut/modules.d/01test/test.sh <<EOF
#!/bin/bash

exec 0<>/dev/console 1<>/dev/console 2<>/dev/console
Hello! You are in dracut module!
 ___________________
< I'm dracut module >
 -------------------
   \
    \
        .--.
       |o_o |
       |:_/ |
      //   \ \
     (|     | )
    / \_   _/ \
    \___)=(___/
msgend
sleep 10
echo " continuing...."
EOF

chmod +x /usr/lib/dracut/modules.d/01test/module-setup.sh
chmod +x /usr/lib/dracut/modules.d/01test/test.sh

mkinitrd -f -v /boot/initramfs-$(uname -r).img $(uname -r)




