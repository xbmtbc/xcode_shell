#!/bin/bash
#--------------------------------------------
# 这是一个安装最新Nginx的脚本
# https://github.com/xbmtbc/xcode_shell/blob/master/Nginx_install.sh
# 功能：CentOS 6.5下最新Nginx 编译安装
# 特色：全自动升级，不需要输入任何参数
#--------------------------------------------
##### 用户配置区 开始 #####
#
# 用户在根目录创建/data/src/soft，下载的nginx-1.8.1.tar.gz源码放进去
# 脚本Nginx_install.sh放在src目录里。
#
##### 用户配置区 结束  #####
#--------------------------------------------
# 作者：xbmtbc
# E-mail:960524501@gqq.com
# 创建日期：2016/03/19
#--------------------------------------------
nginx_version="nginx-1.8.1"
yum install -y pcre-devel libmxl2-devel libxslt-devel gd-devel
groupadd www
useradd -c nginx-user -g www -M nginx
cd soft
tar zxvf $nginx_version".tar.gz"
cd $nginx_version
./configure --prefix=/usr/local/nginx --user=nginx --group=www --with-http_ssl_module --with-http_spdy_module --with-http_realip_module --with-http_addition_module --with-http_xslt_module --with-http_image_filter_module --with-http_sub_module --with-http_auth_request_module --with-http_stub_status_module --with-http_gzip_static_module
make && make install
cd ..
rm -rf $nginx_version
cd ..
chown -R nginx:www /usr/local/nginx
echo '#!/bin/sh
#
# nginx - this script starts and stops the nginx daemin
#
# chkconfig:   - 85 15
# description:  Nginx is an HTTP(S) server, HTTP(S) reverse \
#               proxy and IMAP/POP3 proxy server
# processname: nginx
# config:      /usr/local/nginx/conf/nginx.conf
# pidfile:     /usr/local/nginx/logs/nginx.pid

# Source function library.
. /etc/rc.d/init.d/functions

# Source networking configuration.
. /etc/sysconfig/network

# Check that networking is up.
[ "$NETWORKING" = "no" ] && exit 0

nginx="/usr/local/nginx/sbin/nginx"
prog=$(basename $nginx)

NGINX_CONF_FILE="/usr/local/nginx/conf/nginx.conf"

lockfile=/var/lock/subsys/nginx

start() {
    [ -x $nginx ] || exit 5
    [ -f $NGINX_CONF_FILE ] || exit 6
    echo -n $"Starting $prog: "
    daemon $nginx -c $NGINX_CONF_FILE
    retval=$?
    echo
    [ $retval -eq 0 ] && touch $lockfile
    return $retval
}

stop() {
    echo -n $"Stopping $prog: "
    killproc $prog -QUIT
    retval=$?
    echo
    [ $retval -eq 0 ] && rm -f $lockfile
    return $retval
}

restart() {
    configtest || return $?
    stop
    start
}

reload() {
    configtest || return $?
    echo -n $"Reloading $prog: "
    killproc $nginx -HUP
    RETVAL=$?
    echo
}

force_reload() {
    restart
}

configtest() {
  $nginx -t -c $NGINX_CONF_FILE
}

rh_status() {
    status $prog
}

rh_status_q() {
    rh_status >/dev/null 2>&1
}

case "$1" in
    start)
        rh_status_q && exit 0
        $1
        ;;
    stop)
        rh_status_q || exit 0
        $1
        ;;
    restart|configtest)
        $1
        ;;
    reload)
        rh_status_q || exit 7
        $1
        ;;
    force-reload)
        force_reload
        ;;
    status)
        rh_status
        ;;
    condrestart|try-restart)
        rh_status_q || exit 0
            ;;
    *)
        echo $"Usage: $0 {start|stop|status|restart|condrestart|try-restart|reload|force-reload|configtest}"
        exit 2
esac' > /etc/init.d/nginx
chmod +x /etc/init.d/nginx
chkconfig nginx on
service nginx start
