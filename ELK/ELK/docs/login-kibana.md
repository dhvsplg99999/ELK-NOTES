

## Enable login by Username and Password on Kibana



### Step 1 : Config in Elasticsearch to enable xpack security
```
cat > /etc/elasticearch/elasticsearch.yml << EOF

#---------------------------------- Security -----------------------------------
xpack.security.enabled: true
xpack.security.transport.ssl.enabled: true

EOF
```
### Step 2 : Create user and password 

Go to path : `/usr/share/elasticsearch`

Run the following command from the Elasticsearch directory

```
./bin/elasticsearch-setup-passwords interactive
```


### Step 3 : Add user to Kibana

Config Kibana user in path : ` / etc/kibana/kibana.yml'

```
cat > /etc/kibana/kibana.yml << EOF

#------------------------------ Elasticsearch  --------------------------------
elasticsearch.username: "kibana"
elasticsearch.password: "your_password"
EOF
```
**NOTE** : Khi gửi log từ Logstash đến Elasticsearch do E đã bật xpack security nên ở Output của Logstash đến E cần có thêm trường `user` and `password` 

*Example* :
```
output {
   elasticsearch {
        hosts => [ "172.27.100.30:9200" ]
        user => elastic
        password => "123456"
        sniffing => true
        index => "%{[@metadata][beat]}-%{+YYYY.MM.dd}"
   }
}
```

### Step 5 : Restart service Elasticsearch , Kibana , Logstash

