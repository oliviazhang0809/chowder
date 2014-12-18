echo "installing hbase"
wget https://archive.apache.org/dist/hbase/hbase-0.94.24/hbase-0.94.24.tar.gz
tar xzvf hbase-0.94.24.tar.gz
 rm hbase-0.94.24.tar.gz
mkdir -p /usr/local/hbase
cp -r hbase-0.94.24/* /usr/local/hbase

