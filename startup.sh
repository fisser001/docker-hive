#!/bin/bash

hadoop fs -mkdir       /tmp
hadoop fs -mkdir -p    /user/hive/warehouse
hadoop fs -chmod g+w   /tmp
hadoop fs -chmod g+w   /user/hive/warehouse


hdfs dfs -mkdir -p /apps/tez/
hdfs dfs -chmod -R 777 /apps/tez/

#hdfs dfs -put /apache-tez-$TEZ_VERSION-src/tez-dist/target/tez-$TEZ_VERSION.tar.gz /apps/tez
hdfs dfs -put /tmp/tez-$TEZ_VERSION.tar.gz /apps/tez/
hdfs dfs -chown -R $HDFS_USER:$HADOOP_USER /apps
hadoop fs -chmod g+w /apps/tez
hadoop fs -chmod g+w /apps/tez/*
hdfs dfs -chmod -R 777 /apps/tez/
hdfs dfs -chmod -R 777 /tmp/
cd $HIVE_HOME/bin
./hiveserver2 --hiveconf hive.server2.enable.doAs=false
