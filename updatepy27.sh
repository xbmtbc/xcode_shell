#!/bin/bash
#--------------------------------------------
# 这是一个自动升级python的脚本
# https://github.com/webfrogs/xcode_shell/blob/master/ipa-build
# 功能：centos6.5环境升级Python2.6.6至2.7.10
# 特色：全自动升级，不需要输入任何参数
#--------------------------------------------
##### 用户配置区 开始 #####
#
# 用户在根目录创建/data/src/soft，下载的Python-2.7.10.tgz源码放进去
# 脚本updatepy27.sh放在src目录里。
#
##### 用户配置区 结束  #####
#--------------------------------------------
# 作者：xbmtbc
# E-mail:960524501@gqq.com
# 创建日期：2016/03/19
#--------------------------------------------
python_version="Python-2.7.10"
yum -y groupinstall "Development tools" 
yum -y install zlib-devel bzip2-devel pcre-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel python-devel libxml2  libxml2-devel  python-setuptools  zlib-devel wget openssl-devel pcre pcre-devel sudo gcc make autoconf automake
cd soft
#由于下载速度慢，所有尽量下载好源码
#wget https://www.python.org/ftp/python/2.7.10/Python-2.7.10.tgz
tar -xzf $python_version".tgz"  
cd $python_version  
./configure --prefix=/usr/local/python  
make && make install
cd ..
rm -rf $python_version
cd ..
mv /usr/bin/python /usr/bin/python_old
ln -sf /usr/local/python/bin/python /usr/bin/python
sed -i 's@#!/usr/bin/python@#!/usr/bin/python2.6@' /usr/bin/yum
cd soft
wget https://bootstrap.pypa.io/get-pip.py
python get-pip.py
rm -rf get-pip.py
ln -sf /usr/local/python/bin/pip /usr/bin/pip
ln -sf /usr/local/python/bin/easy_install /usr/bin/easy_install
cd ..
export PATH=$PATH:/usr/local/python/bin
