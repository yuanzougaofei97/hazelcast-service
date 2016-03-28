#!/bin/bash

cp hazelcast.sh /etc/init.d/hazelcast
chmod +x /etc/init.d/hazelcast
chkconfig --add  hazelcast
service hazelcast start
chkconfig hazelcast on

