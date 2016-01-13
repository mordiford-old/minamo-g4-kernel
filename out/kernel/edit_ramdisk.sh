mkdir /tmp/ramdisk
cp /tmp/boot.img-ramdisk.gz /tmp/ramdisk/
cd /tmp/ramdisk/
gunzip -c /tmp/ramdisk/boot.img-ramdisk.gz | cpio -i
cd /

found=$(find /tmp/ramdisk/init.rc -type f | xargs grep -oh "run-parts /system/etc/init.d");
if [ "$found" != 'run-parts /system/etc/init.d' ]; then
        #find busybox in /system
        bblocation=$(find /system/ -name 'busybox')
        if [ -n "$bblocation" ] && [ -e "$bblocation" ] ; then
                echo "BUSYBOX FOUND!";
                #strip possible leading '.'
                bblocation=${bblocation#.};
        else
                echo "BUSYBOX NOT FOUND! init.d support will not work without busybox!";
                echo "Setting busybox location to /system/xbin/busybox! (install it and init.d will work)";
                #set default location since we couldn't find busybox
                bblocation="/system/xbin/busybox";
        fi
        #append the new lines for this option at the bottom
        echo "" >> /tmp/ramdisk/init.rc
        echo "service llama-post-boot /system/bin/sh /init.llama.post_boot.sh" >> /tmp/ramdisk/init.rc
        echo "class late_start" >> /tmp/ramdisk/init.rc
        echo "user root" >> /tmp/ramdisk/init.rc
        echo "disabled" >> /tmp/ramdisk/init.rc
        echo "" >> /tmp/ramdisk/init.rc
        echo "on property:sys.boot_completed=1" >> /tmp/ramdisk/init.rc
        echo "start llama-post-boot" >> /tmp/ramdisk/init.rc
        
fi

cp /tmp/init.llama.post_boot.sh /tmp/ramdisk/init.llama.post_boot.sh

rm /tmp/ramdisk/boot.img-ramdisk.gz
rm /tmp/boot.img-ramdisk.gz
cd /tmp/ramdisk/
find . | cpio -o -H newc | gzip > ../boot.img-ramdisk.gz
cd /
rm -rf /tmp/ramdisk
