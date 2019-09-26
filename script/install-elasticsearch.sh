#!/bin/bash
#update package
yum update -y

# Install java, wget 
	yum install -y java-1.8.0-openjdk wget
	cp /etc/profile /etc/profile_backup
        echo 'export JAVA_HOME=/usr/lib/jvm/jre-1.8.0-openjdk' | sudo tee -a /etc/profile
        echo 'export JRE_HOME=/usr/lib/jvm/jre' | sudo tee -a /etc/profile
        source /etc/profile
# Import key elasticsearch
	rpm --import http://packages.elastic.co/GPG-KEY-elasticsearch
# Add repo elasticsearch 
cat <<EOF > /etc/yum.repos.d/elasticsearch.repo
[elasticsearch-7.x]
name=Elasticsearch repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOF
#Install elasticsearch 
	yum install elasticsearch -y
	systemctl start elasticsearch 
	systemctl enable elasticsearch 

# Open port in firewalld
	firewall-cmd --add-port=9200/tcp --permanent
   	firewall-cmd --relooad


