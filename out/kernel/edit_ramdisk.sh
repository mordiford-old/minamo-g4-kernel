mkdir /tmp/ramdisk
cp /tmp/boot.img-ramdisk.gz /tmp/ramdisk/
cd /tmp/ramdisk/
gunzip -c /tmp/ramdisk/boot.img-ramdisk.gz | cpio -i
cd /

#append the new lines for this option at the bottom
echo "" >> /tmp/ramdisk/init.qcom.rc
echo "service llama-post-boot /system/bin/sh /init.llama.post_boot.sh" >> /tmp/ramdisk/init.qcom.rc
echo "class late_start" >> /tmp/ramdisk/init.qcom.rc
echo "user root" >> /tmp/ramdisk/init.qcom.rc
echo "disabled" >> /tmp/ramdisk/init.qcom.rc
echo "" >> /tmp/ramdisk/init.qcom.rc
echo "on property:sys.boot_completed=1" >> /tmp/ramdisk/init.qcom.rc
echo "start llama-post-boot" >> /tmp/ramdisk/init.qcom.rc
        


cp /tmp/init.llama.post_boot.sh /tmp/ramdisk/init.llama.post_boot.sh

rm /tmp/ramdisk/boot.img-ramdisk.gz
rm /tmp/boot.img-ramdisk.gz
cd /tmp/ramdisk/
find . | cpio -o -H newc | gzip > ../boot.img-ramdisk.gz
cd /
rm -rf /tmp/ramdisk
