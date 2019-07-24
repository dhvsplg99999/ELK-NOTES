## 2.Các Bước cài đặt ELK Stack (CENTOS 7)

Vì ELK Stack là tập hợp của ba phần mềm lại tạo thành một ứng dụng hoàn chỉnh vi thể để cài đặt được cụm ELK Stack chúng ta sẽ tiến hành cài đặt lần lượt từng phân mèm ELasticsearch, Logstash và Kibana.

Phần mềm cần thiết trước khi cài đặt ELK đó là : Java.


### 2.1: Cài đặt Elasticsearch 

Import key elastic:

```
rpm --import http://packages.elastic.co/GPG-KEY-elasticsearch
```

Thêm repo :
```
cat <<EOF > /etc/yum.repos.d/elasticsearch.repo
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

cài đặt Elasticsearch:
> yum install elasticsearch -y 

Chỉnh sửa file /etc/elasticsearch/elasticsearch.yml: ( sửa dòng network.host như sau )
```
network.host: localhost
```

Khởi động lại dịch vụ và cho phép dịch vụ khởi động cùng hê thống !

 Kiểm tra hoạt động của Elasticsearch :
 > curl -X GET http://localhost:9200

 Kết quả trả về : 
 ```
 {
"name" : "w5M4X9m",
"cluster_name" : "elasticsearch",
"cluster_uuid" : "3a8frDXuRUaxZnKi1Y_tFQ",
"version" : {
    "number" : "6.3.1",
    "build_flavor" : "default",
    "build_type" : "rpm",
    "build_hash" : "eb782d0",
    "build_date" : "2019-01-30T10:21:26.107521Z",
    "build_snapshot" : false,
    "lucene_version" : "7.3.1",
    "minimum_wire_compatibility_version" : "5.6.0",
    "minimum_index_compatibility_version" : "5.0.0"
},
"tagline" : "You Know, for Search"
}

```

### 2.2: Cài đặt Logstash

Thêm repo Logstash:

```
cat << EOF > /etc/yum.repos.d/logstash.repo
[logstash-6.x]
name=Elastic repository for 6.x packages
baseurl=https://artifacts.elastic.co/packages/6.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOF
```

Cài đặt logstash :
> yum install logstash -y 

Khởi động và cho phép khởi động cùng hệ thống 

### 2.3: Cài đặt Kibana 

Tạo repo và cài đặt Kibana:
```
cat <<EOF > /etc/yum.repos.d/kibana.repo
[kibana-6.x]
name=Kibana repository for 6.x packages
baseurl=https://artifacts.elastic.co/packages/6.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOF
```

 Cài đặt kibana :
```
 yum install kibana -y 
sed -i 's/#server.host: "localhost"/server.host: "0.0.0.0"/'g /etc/kibana/kibana.yml
```


**NOTE** : `sed` là lệnh ghi đè lên file ( ví dụ như sẽ ghi đè server.host : localhost thành 0.0.0.0)

Khởi động và cho phép cài đặt cùng hệ thống 

TRuy cập vào Kibana kiểm tra : 
```
http://ip-elk_server:5601
```
[BACK](../README.md)