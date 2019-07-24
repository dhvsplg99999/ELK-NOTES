
#!/bin/bash
cd ~

#INSTALL FILEBEAT

curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.2.0-x86_64.rpm
sudo rpm -vi filebeat-7.2.0-x86_64.rpm

echo "==============INSTALL FILEBEAT DONE==============="
# SET IP ENVIROMENT VARIABLE

export IP_HOME="$(ip -4 addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')"

# CONFIGRUATE FILEBEAT

cp /etc/filebeat/filebeat.yml /etc/filebeat/filebeat.yml.orig
rm -rf /etc/filebeat/filebeat.yml

# CONFIGRUATE /etc/filebeat/filebeat.yml :

cat >> /etc/filebeat/filebeat.yml << EOF
filebeat.inputs:
- type : log
  paths:
    -  /var/log/secure
processors:
- add_fields:
    target: serverIP
    fields:
      ip: $IP_HOME
- drop_fields:
    fields: ["log", "ecs", "input", "agent"]
output.logstash:
    hosts: ["172.27.100.30:5044"]
    worker: 2
    bulk_max_size: 2048
EOF


echo "================CONFIG DONE=================="

systemctl restart filebeat
systemctl enable filebeat
systemctl status filebeat

