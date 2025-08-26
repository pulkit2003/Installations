apt install wget -y
apt install unzip -y
wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.108/bin/apache-tomcat-9.0.108.zip
unzip apache-tomcat-9.0.108.zip

cd apache-tomcat-9.0.108/bin
chmod +x *.sh
./startup.sh
