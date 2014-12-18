# install java7
wget https://raw.githubusercontent.com/oliviazhang0809/grafana/master/java-7-install.sh --no-check-certificate
sudo /bin/bash java-7-install.sh

echo "installing hbase"
wget https://archive.apache.org/dist/hbase/hbase-0.94.24/hbase-0.94.24.tar.gz
tar xzvf hbase-0.94.24.tar.gz
 rm hbase-0.94.24.tar.gz
mkdir -p /usr/local/hbase
cp -r hbase-0.94.24/* /usr/local/hbase

# TODO configure hbase
# TODO start hbase

echo "installing gnuplot"
sudo rm /etc/yum.repos.d/CentOS-Base.repo
wget https://raw.githubusercontent.com/oliviazhang0809/grafana/master/openTSDB/CentOS-Base.repo -O /etc/yum.repos.d/CentOS-Base.repo --no-check-certificate
yum -y install gnuplot

echo "installing openTSDB"
rpm -Uvh https://github.com/OpenTSDB/opentsdb/releases/download/v2.1.0RC1/opentsdb-2.1.0RC1.noarch.rpm
