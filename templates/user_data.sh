#!/bin/bash

apt-get update

# conf.d files
curl -o /etc/logstash/conf.d/${conf_1_name} ${conf_1_file}

# start logstash
sudo systemctl start logstash.service
