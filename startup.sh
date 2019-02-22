#!/bin/bash

hadoop fs -mkdir       /tmp
hadoop fs -mkdir -p    /user/hive/warehouse
hadoop fs -chmod g+w   /tmp
hadoop fs -chmod g+w   /user/hive/warehouse


hdfs dfs -mkdir -p /apps/tez/

hdfs dfs -put /tmp/tez.tar.gz /apps/tez/
hdfs dfs -chown -R $HDFS_USER:$HADOOP_USER /apps
hadoop fs -chmod g+w /apps/tez
hadoop fs -chmod g+w /apps/tez/*

cd $HIVE_HOME/bin
./hiveserver2 --hiveconf hive.server2.enable.doAs=false
