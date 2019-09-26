#!/bin/bash
#update package
yum update -y

# Install java, wget 
	yum install -y java-1.8.0-openjdk wget
	cp /etc/profile /etc/profile_backup
        echo 'export JAVA_HOME=/usr/lib/jvm/jre-1.8.0-openjdk' | sudo tee -a /etc/profile
        echo 'export JRE_HOME=/usr/lib/jvm/jre' | sudo tee -a /etc/profile
        source /etc/profile
# Import key kibana
	rpm --import http://packages.elastic.co/GPG-KEY-elasticsearch
# Add repo kibana 
cat <<EOF > /etc/yum.repos.d/elasticsearch.repo
[kibana-7.x]
name=Kibana repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
EOF
#Install kibana
	yum install kibana -y
	systemctl start kibana
	systemctl enable kibana
# Open port in firewalld
	firewall-cmd --add-port=5601/tcp --permanent
   	firewall-cmd --relooad



