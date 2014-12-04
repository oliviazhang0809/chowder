#!/bin/bash
# install heka

# add hekad-user
#useradd -d / -M -U -c "hekad-user" -s /usr/sbin/nologin heka

useradd hekadUser
# create directory
mkdir /etc/hekad
mkdir -p /opt/hekad/shared
mkdir -p /var/cache/hekad

# install heka
wget -O awesome_heka.rpm "https://github.com/mozilla-services/heka/releases/download/v0.8.0/heka-0_8_0-linux-amd64.rpm"
rpm -ivh awesome_heka.rpm
rm awesome_heka.rpm

# install daemon
wget http://libslack.org/daemon/download/daemon-0.6.4-1.x86_64.rpm
rpm -ivh daemon-0.6.4-1.x86_64.rpm
rm daemon-0.6.4-1.x86_64.rpm

# fetch predefined config.toml
cd /opt/hekad/shared
wget https://raw.githubusercontent.com/oliviazhang0809/grafana/master/heka/config.toml --no-check-certificate
cd /etc/hekad
wget https://raw.githubusercontent.com/oliviazhang0809/grafana/master/heka/init.sh --no-check-certificate

# change user right
chown -R hekadUser:hekadUser /etc/hekad
chown -R hekadUser:hekadUser /var/cache/hekad
chown -R hekadUser:hekadUser /opt/hekad

# make hekad service
chmod +x /etc/hekad/init.sh
mv /etc/hekad/init.sh /etc/init.d/hekad

# start daemon
service hekad start