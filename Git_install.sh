#!/bin/bash
#--------------------------------------------
# 这是一个自动安装Git最新版的脚本
# https://github.com/xbmtbc/xcode_shell/blob/master/Git_install.sh
# 功能：CentOS6.5下安装最新版Git
# 特色：全自动升级，不需要输入任何参数
#--------------------------------------------
##### 用户配置区 开始 #####
#
# 用户在根目录创建/data/src/soft，下载的Git最新版源码放进去
# 脚本Git_install.sh放在src目录里。
#
##### 用户配置区 结束  #####
#--------------------------------------------
# 作者：xbmtbc
# E-mail:960524501@qq.com
# 创建日期：2016/03/26
#--------------------------------------------
yum -y install unzip
cd soft
wget https://github.com/git/git/archive/master.zip
unzip master.zip
cd git-master
yum -y install curl-devel expat-devel gettext-devel openssl-devel zlib-devel gcc perl-ExtUtils-MakeMaker
autoconf
make prefix=/usr/local/git all
make prefix=/usr/local/git install
cd ..
rm -rf git-master
cd ..
echo 'export PATH=$PATH:/usr/local/git/bin' >> /etc/bashrc
source /etc/bashrc
rm -rf /usr/bin/git
ln -s -f /usr/local/git/bin/git /usr/bin/git
git --version
