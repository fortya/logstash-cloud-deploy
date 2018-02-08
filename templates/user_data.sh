#!/bin/bash

apt-get update

cd /etc/logstash/conf.d
curl -o ${conf_1_name} ${conf_1_file}
