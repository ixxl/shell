#!/bin/bash
#
#####################################################################
touch /root/test1
sp=100


disk=`fdisk -l | grep "/dev/sda" | awk '{if($2~/sd/) print substr($2,0,8)}'`
echo " disk is $disk"

mkdir /mnt
mkdir /u01

parted /dev/sdb  << EXIT0
 mkpart mnt 20G 25G
 mkpart u01 25G 60G
 quit
EXIT0

mkfs.xfs -f /dev/sdb5
mount /dev/sdb5 /mnt
uuid5=`blkid | grep /dev/sdb5 | awk '{print $2}'|awk -F"\"" '{print $2}'`
cat << EXITMNT > /root/test1
UUID=$uuid5      /mnt       xfs    defaults                0 0
EXITMNT
    cat /root/test1 >> /etc/fstab

mkfs.ext4 /dev/sdb6
mount /dev/sdb6 /u01
uuid6=`blkid | grep /dev/sdb6 | awk '{print $2}'|awk -F"\"" '{print $2}'`
    cat << EXITU01 > /root/test1
UUID=$uuid6      /u01       ext4    defaults                0 0
EXITU01
    cat /root/test1 >> /etc/fstab


for num in {1..40}
do
	if (($num == 1))
	then
	parted $disk  << EXIT2
mkpart part$num 0% $(($num*$sp))G
ignore
quit
EXIT2
	elif (($num == 40))
        then
        parted $disk  << EXIT3
mkpart part$num $(($(($num-1))*$sp))G 100%
ignore
quit
EXIT3
	else
	parted $disk  << EXIT4
 mkpart part$num $(($(($num-1))*$sp))G $(($num*$sp))G 
 ignore
 quit
EXIT4
	fi
	mkfs.xfs -f $disk$num

	echo "/n/n****************$disk_was Fdisked!Waithing For 1 second****/n/n"

	sleep 1s

	mkdir -p /pic/data${num}

    cat << EXIT5 > /root/test1
$disk$num      /pic/data${num}       xfs    defaults                0 0
EXIT5
    cat /root/test1 >> /etc/fstab
	
	mount $disk$num /pic/data${num} 
	
	sleep 1s
done


