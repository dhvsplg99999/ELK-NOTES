## Filebeats


### 1. Filebeat là gì ?

Filebeat là một công cụ dùng để gửi file log từ client lên đến server ELK ( có nhiều kiểu server quản lý log nhưng ở đây mình dùng ELK )

#### Mô hình hoạt động của filebeat ...
(  Hãy đọc phần này khi bạn đã biết qua Elasticsearch và Logstash có những nhiệm vụ gì )

<img src="../images/filebeat.png">

Khi filebeat chạy , nó sẽ chạy một hoặc nhiều  tiến trình input  có đường đẫn đến thư mục chứa log . Với mỗi thư mục chứa log filebeat sẽ tiến hành chạy một ` harvester ` ( harvestor có nhiệm vụ đọc dữ liệu trong từng file log ) để gửi  dữ liệu lên ` Spooler ` ( là nơi tổng hợp lại tất cả các nội dung của các file log ) và sau đó spooler sẽ chuyển dữ liệu đến nơi mà Filebeat chỉ định output tại file configured .

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


output.logstash:
    hosts: ["172.27.100.30:5044"]
    worker: 2
    bulk_max_size: 2048

EOF
```

Khi cấu hình file config của filebeats ban đầu chúng ta sẽ định nghĩa đầu vào ` input `  như ở ví dụ trên các thành phần được khai báo trong mục input đó là `type`, `path`.
- **TYPE**: là loại dữ liệu truyền vào cho filebeat (ở trên ví dụ loại dữ liệu truyền vào là `log`). Bạn có thể khai báo các loại dữ liệu truyền vào khác:
    - log
    - Stdin
    - Container
    - Redis
    - UDP
    - Docker
    - TCP
    - Syslog
    - NetFlow
    - Google Pub/Sub
- **PATH**: là đường dẫn đến thư mục mà bạn định truyền dữ liệu vào cho filebeat.

Ở phần `output` chúng ta sẽ sử dụng plugin của filebeat gửi dữ liệu cho logstash. Các thông tin kèm theo đó là : `hosts`(là địa chỉ ip của logstash ), `worker`(số lượng tiến trình sử dụng để gửi dữ liệu ), `bulk_max_size`(độ dài tối đa của một lần gửi dữ liệu ).

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

Output của Logstash chúng ta sẽ dùng plugin `elasticsearch` với các thông tin `hosts` (địa chỉ mà logstash sẽ gửi dữ liệu đến ), `index` (đặt tên cho index để gửi event đến cho elasticsearch  )
Lên Kibana kiểm  tra xem log đã được đẩy lên hay chưa 
Truy cập : ip-elk-server:5061 

Click Management:

<img src="../images/Kibana-check1.png.jpg">

Click Index Patterns => Create Index Patterns => Điền vào Index pattern rồi Next Step.

<img src="../images/Kibana-check2.png.jpg">

Thông tin về lpg sẽ hiện lên tại Discover

<img src="../images/Kibana-check3.png.jpg">

[BACK](../README.md)


