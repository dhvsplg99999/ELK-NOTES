## Filebeats


### 1. Filebeat là gì ?

Filebeat là một công cụ dùng để gửi file log từ client lên đến server ELK ( có nhiều kiểu server quản lý log nhưng ở đaay mình dùng ELK )

#### Mô hình hoạt động của filebeat ...
(  Hãy đọc phần này khi bạn đã biết qua Elasticsearch và Logstash có những nhiệm vụ gì )

<img src="../images/filebeat.png">

Khi filebeat chạy , nó sẽ chạy một hoặc nhiều  tiến trình input  có đường đẫn đến thư mục chưa log . Với mỗi thư mục chưa log filebeat sẽ tiến hành chạy một ` harvester ` ( harvestor có nhiệm vụ đọc dữ liệu trong từng file log ) để gửi  dữ liệu lên ` Spooler ` ( là nươi tổng hợp lại tất cả các nội dung của các file log ) và sau đó spooler sẽ chuyển dữ liệu đến nơi mà Filebeat chỉ định output tại file configured .

 Output có thể gửi trực tiếp lên Elasticsearch hoặc gửi qua logstash để xử lý ( với hệ thống lớn có nhiều dữ liệu gửi lên sẽ có thêm Kafka và Redis là cache để chuyển dữ liệu lên server lưu trữ data)

 

### 2. Cài đặt filebeat từ client CentOS vè ELLK Stack 

add repo :
```
cat > /etc/yum.repos.d/elastic.repo << EOF
[elasticsearch-6.x]
name=Elasticsearch repository for 6.x packages
baseurl=https://artifacts.elastic.co/packages/6.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOF
```

Cài đặt filebeat :
yum install filebeat-6.2.4 -y 

backup cấu hình của filebeat:
```
cp /etc/filebeat/filebeat.yml /etc/filebeat/filebeat.yml.orig
rm -rf /etc/filebeat/filebeat.yml
touch /etc/filebeat/filebeat.yml
```

Sửa file cấu hình của filebeat tại /etc/filebeat/filebeat.yml như sau :

```
cat > /etc/filebeat/filebeat.yml << EOF
filebeat.inputs:
- type: log
  paths:
    - /var/log/*.log
registry_file: /var/lib/filebeat/registry

output.logstash:
    hosts: ["172.27.100.30:5044"]
    worker: 2
    bulk_max_size: 2048
logging:
to_syslog: false
to_files: true
files:
    path: /var/log/filebeat
    name: filebeat
    rotateeverybytes: 1048576000 # = 1GB
    keepfiles: 7
selectors: ["*"]
level: info
EOF
```

Khởi dộng lại filebeat


### Cấu hình Logstash trên Server


Tạo file config của logstash để thiết lập input và output 

> touch /etc/logstash/conf.d/02-logstash.conf

Thêm vào file cấu hình `  /etc/logstash/conf.d/02-logstash.conf ` nộidung :
```
input {
beats {
    port => 5044
    ssl => false
}
}

output {
    elasticsearch {
    hosts => ["localhost:9200"]
    sniffing => true
    index => "%{[@metadata][beat]}-%{+YYYY.MM.dd}"
    }
}

```
Lên Kibana kiểm  tra xem log đã được đẩy lên hay chưa 
Truy cập : ip-elk-server:5061 

Click Management:

<img src="../images/Kibana-check1.png">

Click Index Patterns => Create Index Patterns => Điền vào Index pattern rồi Next Step.

<img src="../images/Kibana-check2.png">

Thông tin về lpg sẽ hiện lên tại Discover

<img src="../images/Kibana-check3.png">

[BACK](../README.md)


