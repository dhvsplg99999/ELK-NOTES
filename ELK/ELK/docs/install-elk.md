## Install ELK Stackon 3 Nodes ( On CENTOS 7 )



### Step 1 : Install Elasticsearch 

Download and install the public signing key

```
 rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
 ```

Add repo elasticsearch
```
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
```
Install elasticsearch
```
        yum install elasticsearch -y
        systemctl start elasticsearch
        systemctl enable elasticsearch
```
Open port in firewalld
```
        firewall-cmd --add-port=9200/tcp --permanent
        firewall-cmd --relooad
```

Config in file ` /etc/elascticsearch/elasticsearch.yml` 
```
cat  > /etc/elascticsearch/elasticsearch.yml <<EOF 
network.host: _eth0_
http.port: 9200
discovery.seed_hosts: ["your_gateway_IP", "[:::]", "[::1]"]
EOF
```

### Step 2 : Install Logstash 

Import key logstash
```
	rpm --import http://packages.elastic.co/GPG-KEY-elasticsearch
```
Add repo logstash 
```
cat <<EOF > /etc/yum.repos.d/logstash.repo
[logstash-7.x]
name=Elastic repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOF
```
Install logstash 
```
	yum install logstash -y
	systemctl start logstash
	systemctl enable logstash
```


### Step 3 : Install Kibana 

Import key kibana
```
	rpm --import http://packages.elastic.co/GPG-KEY-elasticsearch
```
Add repo kibana 
```
cat <<EOF > /etc/yum.repos.d/elasticsearch.repo
[kibana-7.x]
name=Kibana repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
EOF
```
Install kibana
```
	yum install kibana -y
	systemctl start kibana
	systemctl enable kibana
```
Open port in firewalld
```
	firewall-cmd --add-port=5601/tcp --permanent
   	firewall-cmd --relooad
``` 
Config in file `/etc/kibana/kibana.yml`
```
cat > /etc/kibana/kibana.yml << EOF
elasticsearch.hosts: ["http://your_elasticsearch_IP:9200"]
EOF
```





