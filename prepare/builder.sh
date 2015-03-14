# prepare a new builder

# install necessities
yum -y install openjdk-7-jdk
yum -y install maven git

# install sbt and scala
curl https://bintray.com/sbt/rpm/rpm | sudo tee /etc/yum.repos.d/bintray-sbt-rpm.repo
sudo yum install sbt
rpm -ivh http://www.scala-lang.org/files/archive/scala-2.11.2.rpm