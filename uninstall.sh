#!/bin/bash

chkconfig --del  hazelcast
service hazelcast stop
rm -rf /etc/init.d/hazelcast

