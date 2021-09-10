#!/bin/bash
#

mode=$(cat /mnt/soft/softv/config.ini| grep start4 |cut -d'=' -f 2 | tr -d [:space:])
echo $mode

if [ "$mode" == "3" ] ; then
  while true
    do
      count=`ps -ef |grep "oracle"|grep -v grep`

      if [ "$?" -ne 0 ];then
	 echo  ">>>> oracle is not running,run it now..."
	 su - oracle -c /u01/app/oracle_scripts/dbstart.pl
      else
	 echo ">>>> oracle is runing..."
      fi
    sleep 30
  done

else 
  echo ">>>> mode is ERIS <<<<"
fi


