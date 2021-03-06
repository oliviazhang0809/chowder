# install java7
wget https://raw.githubusercontent.com/oliviazhang0809/grafana/master/java-install.sh --no-check-certificate
sudo /bin/bash java-install.sh
rm java-install.sh

# install default
yum -y install git

echo "installing hbase"
wget https://archive.apache.org/dist/hbase/hbase-0.94.24/hbase-0.94.24.tar.gz
tar xzvf hbase-0.94.24.tar.gz
rm hbase-0.94.24.tar.gz
mkdir -p /usr/local/hbase
cp -r hbase-0.94.24/* /usr/local/hbase

#configure hbase
rm -rf hbase-0.94.24
# configure hbase-env.sh
rm /usr/local/hbase/conf/hbase-env.sh
wget https://raw.githubusercontent.com/oliviazhang0809/grafana/master/openTSDB/hbase-env.sh -O /usr/local/hbase/conf/hbase-env.sh --no-check-certificate
# configure hbase-site.xml
rm /usr/local/hbase/conf/hbase-site.xml
wget https://raw.githubusercontent.com/oliviazhang0809/grafana/master/openTSDB/hbase-site.xml -O /usr/local/hbase/conf/hbase-site.xml --no-check-certificate
echo "starting hbase"
/usr/local/hbase/bin/start-hbase.sh

echo "installing gnuplot"
sudo rm /etc/yum.repos.d/CentOS-Base.repo
wget https://raw.githubusercontent.com/oliviazhang0809/grafana/master/openTSDB/CentOS-Base.repo -O /etc/yum.repos.d/CentOS-Base.repo --no-check-certificate
yum -y install gnuplot

echo "installing openTSDB"
yum -y install install autoconf automake libtool
git clone git://github.com/OpenTSDB/opentsdb.git
cd opentsdb
./build.sh

echo "creating tables in opentsdb"
env COMPRESSION=NONE HBASE_HOME=/usr/local/hbase ./src/create_table.sh

