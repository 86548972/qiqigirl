#!/bin/bash

wget -P /etc/yum.repos.d/  https://mirrors.aliyun.com/repo/Centos-7.repo
wget -P /etc/yum.repos.d/  https://mirrors.aliyun.com/repo/epel-7.repo

yum -y install vim iotop bc gcc gcc-c++ glibc glibc-devel pcre pcre-devel openssl  openssl-devel zip unzip zlib-devel  net-tools lrzsz tree ntpdate telnet lsof tcpdump wget libevent libevent-devel bc  systemd-devel bash-completion traceroute
