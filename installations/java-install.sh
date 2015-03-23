echo "Installing java on centOS..."
cd /opt
sudo wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" \
"http://download.oracle.com/otn-pub/java/jdk/7u71-b14/jdk-7u71-linux-x64.tar.gz" -O /opt/jdk-7u71-linux-x64.tar.gz
sudo tar xvf /opt/jdk-7u71-linux-x64.tar.gz
sudo chown -R root: jdk1.7.0_71
sudo alternatives --install /usr/bin/java java /opt/jdk1.7.0_71/bin/java 1
sudo alternatives --install /usr/bin/javac javac /opt/jdk1.7.0_71/bin/javac 1
sudo alternatives --install /usr/bin/jar jar /opt/jdk1.7.0_71/bin/jar 1
java -version
