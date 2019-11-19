#!/bin/bash
#
#********************************************************************
#Date: 			2019-11-19
#FileName：		ceshixxx.sh
#Description：		The test script
#Copyright (C): 	2019 All rights reserved
#********************************************************************
DIR=`pwd`
NAME="mariadb-10.2.29-linux-x86_64.tar.gz"
Name="mariadb-10.2.29-linux-x86_64"
FULL_NAME=${DIR}/${NAME}
SockPath="/var/lib/mysql/mysql.sock"
yum -y install libaio wget expect  lsof 

if [ -f $FULL_NAME ]; then
		echo "安装包已存在"
	else
		echo "请检查安装包的位置"
		exit 3
fi

if [ -h /usr/local/mysql  ]; then
		echo "mysql已经安装"
		exit 6
else
	if id mysql ;then
			echo "mysql用户已经存在"
		else
			useradd -r mysql -s /sbin/nologin
	fi

	tar xvf $FULL_NAME -C /usr/local
	ln -s /usr/local/$Name /usr/local/mysql
	chown -R mysql.mysql /usr/local/mysql
	ln -s /usr/local/mysql/bin/* /usr/bin
	cp -rf my.cnf /etc/
	/usr/local/mysql/scripts/mysql_install_db --datadir=/data/mysql --user=mysql
	cp /usr/local/mysql/support-files/mysql.server  /etc/init.d/mysqld
	/etc/init.d/mysqld start 

 	
fi
        lsof -i:3306 &>/dev/null &&  echo "mysql成功安装完毕" || (echo "mysql安装过程出错，端口没启动请检查";exit 7)


#初始化mysql脚本
PASSWD="centos"
ln -s $SockPath /tmp
expect <<OVER
set timeout 10
spawn /usr/local/mysql/bin/mysql_secure_installation 
expect {
"(enter for none)" {send "\n";exp_continue}
"Set root password"  {send "y\n";exp_continue}
"New password:" {send "${PASSWD}\n";exp_continue}
"Re-enter new password:" {send "${PASSWD}\n";exp_continue}
"users"  {send "y\n";exp_continue}
"remotely"  {send "y\n";exp_continue}
"access to it"  {send "y\n";exp_continue}
"tables now" {send "y\n";exp_continue}
}
expect eof
OVER

