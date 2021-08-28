#!/bin/sh

echo "========================SERVER SETUP========================"
systemctl mask firewalld
systemctl stop firewalld
yum remove -y firewalld
yum -y install yum-utils iptables-services psmisc wget
rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
chmod +x /etc/rc.d/rc.local


############################
echo "root:ilove87" | sudo chpasswd
############################
setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

service iptables stop
yum remove -y squid haproxy mongodb mongodb-devel mongodb-server
yum remove -y httpd php php* php-bcmath php-cli php-common php-devel php-fpm php-gd php-curl php-bcmath php-imapyum php-ldap php-mbstring php-mcrypt php-mysql php-odbc php-pdo php-pear php-pecl-igbinary php-xml php-xmlrpc
/bin/cp /usr/share/zoneinfo/Asia/Taipei /etc/localtime
timedatectl set-local-rtc yes
timedatectl set-timezone Asia/Taipei
timedatectl set-ntp yes
ntpdate -s time.stdtime.gov.tw
hwclock --systohc

##############SSH PORT 1122
sed -i 's/#Port 22/Port 1122/g' /etc/ssh/sshd_config
mkdir /home/wwwroot
mkdir /home/wwwroot/default


############################BASIC
yum -y install yum-utils yum-fastestmirror iotop iostat sshpass aria2 strace nasm lsof dos2unix
yum -y install unzip zip ftp ntp wget mtr iptraf nload traceroute httpd-tools nscd
yum -y install memcached rsync fontconfig zlib zlib-devel libnet-devel libpcap-devel
yum -y install setuptool system-config-network* system-config-firewall* system-config-securitylevel-tui system-config-keyboard ntsysv libevent-devel
yum groupinstall -y "Development tools"
yum install -y openssl openssl-devel
yum -y update

echo "========================NET CORE SETUP========================"
############################.Net 5
sudo rpm -Uvh https://packages.microsoft.com/config/centos/7/packages-microsoft-prod.rpm
sudo yum install dotnet-sdk-5.0 dotnet-runtime-5.0 aspnetcore-runtime-5.0 openssh-server unzip curl -y

echo "========================PHP 7.2 SETUP========================"
############################PHP
yum-config-manager --enable remi-php72
yum install -y php php-fpm php-common  php-pear php-cli php-devel php-pdo php-mysqlnd php-mbstring php-gd php-tidy php-xml php-ssh2 php-xmlrpc php-pear php-imap php-opcache php-process php-redis php-bcmath
yum install -y php72-php-pecl-mongodb php72-php-pecl-redis php72-php-mysqlnd php-pecl-memcache php-pecl-zip
sed -i 's/user = apache/user = nginx/g' /etc/php-fpm.d/www.conf
sed -i 's/group = apache/group = nginx/g' /etc/php-fpm.d/www.conf
sed -i 's/pm = dynamic/pm = static/g' /etc/php-fpm.d/www.conf
sed -i 's/pm.max_children = 50/pm.max_children = 80/g' /etc/php-fpm.d/www.conf
##vi /etc/php.ini
sed -i 's/memory_limit = 128M/memory_limit = 1024M/g' /etc/php.ini
sed -i 's/short_open_tag = Off/short_open_tag = On/g' /etc/php.ini
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer 


#######################ImageMagick
yum install ImageMagick ImageMagick-devel -y
printf "\n" | pecl install imagick
echo "extension=imagick.so" >> /etc/php.ini
#####################################

echo "========================SWOOLE SETUP========================"
############################SWLLOE
yum install -y libevent-devel openssl-devel nghttp2 libnghttp2-devel
echo "extension=sockets.so" >> /etc/php.ini
############################
pecl install mongodb
echo "extension=mongodb.so" >> /etc/php.ini
############################
yum install -y centos-release-scl devtoolset-7-toolchain
yum install -y centos-release-scl devtoolset-7-toolchain
scl enable devtoolset-7 bash
gcc --version
############################
rm -f /usr/bin/gcc-bak
rm -f /usr/bin/g++-bak
rm -f /usr/bin/c++-bak
mv /usr/bin/gcc /usr/bin/gcc-bak
mv /usr/bin/g++ /usr/bin/g++-bak
mv /usr/bin/c++ /usr/bin/c++-bak
ln -s /opt/rh/devtoolset-7/root/usr/bin/gcc /usr/bin/gcc
ln -s /opt/rh/devtoolset-7/root/usr/bin/c++ /usr/bin/c++
ln -s /opt/rh/devtoolset-7/root/usr/bin/g++ /usr/bin/g++
echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib" >> ~/.bash_profile
############################
printf "yes\nyes\nyes\nno\nno\nno\n" | pecl install swoole
echo "extension=swoole.so" >> /etc/php.ini
php -m | grep swoole

####################################PHP_START
cd /home/wwwroot/
wget https://github.com/kenchan97/rawfiles.github.io/blob/gh-pages/wwwroot.zip?raw=true -O wwwroot.zip
unzip wwwroot.zip
#rm -f wwwroot.zip
yum remove -y supervisor crontabs
ls /home/wwwroot/serverRun.sh
chmod +x /etc/rc.d/rc.local
chmod +x /home/wwwroot/serverRun.sh
sed -i '/serverRun/d' /etc/rc.local
sed -i '/serverRun/d' /etc/rc.d/rc.local
sed -i '/aria2c/d' /etc/rc.d/rc.local
echo '/home/wwwroot/serverRun.sh' >> /etc/rc.d/rc.local
dos2unix /home/wwwroot/serverRun.sh
echo "========================REBOOT========================"
reboot
