#!/bin/bash
echo "installing puppet"
rpm -ivh http://yum.puppetlabs.com/el/6/products/i386/puppetlabs-release-6-7.noarch.rpm

echo "installing rvm"
yum -y groupinstall "Development Tools"
yum -y install zlib zlib-devel sqlite-devel
yum -y install gcc-c++ patch readline readline-devel zlib zlib-devel 
yum -y install libyaml-devel libffi-devel openssl-devel make 
yum -y install bzip2 autoconf automake libtool bison iconv-devel
sudo gpg2 --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
curl -L get.rvm.io | bash -s stable
source /etc/profile.d/rvm.sh

echo "installing Ruby 2.1.2"
#curl -#L https://get.rvm.io | bash -s stable --autolibs=3 --ruby=1.9.3
rvm install 2.1.2
rvm use 2.1.2 --default

echo "installing librarian-puppet"
gem install --no-rdoc --no-ri librarian-puppet

echo "creating modules"
cp /vagrant/Puppetfile /etc/puppet/
cd /etc/puppet
#gem install puppet
librarian-puppet install
