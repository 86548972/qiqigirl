#!/bin/bash
#
#********************************************************************
#Date: 			2019-11-26
#FileName：		backmysql.sh
#Description：		The test script
#Copyright (C): 	2019 All rights reserved
#********************************************************************

BAK_TIME=`date +%F-%T`
USER_PSWD="centos"
USER_NAME="root"
SOCKET="/var/lib/mysql/mysql.sock"
MYLOGIN="mysql -u${USER_NAME} -p${USER_PSWD} -S ${SOCKET}"
DUMP_CMD="/usr/local/mysql/bin/mysqldump -u${USER_NAME} -p${USER_PSWD} -S ${MYLOGIN} --single_transaction --master-data=2 --flush-logs --skip-add-drop-table -B"
DATABASE=`$MYLOGIN -e "SHOW DATABASES;"| grep -Ev "schema|mysql|test|Database"`

for dbname in ${DATABASE}
	do
	MYDIR=/data/backup/${dbname}
	[ ! -d ${MYDIR} ] && mkdir -p ${MYDIR}
	$DUMP_CMD ${dbname} | bzip2 >${MYDIR}/${dbname}_${BAK_TIME}.sql.bz2
done
