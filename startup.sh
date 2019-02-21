#!/bin/bash

hadoop fs -mkdir       /tmp
hadoop fs -mkdir -p    /user/hive/warehouse
hadoop fs -chmod g+w   /tmp
hadoop fs -chmod g+w   /user/hive/warehouse


hdfs dfs -mkdir -p /hadoop/apps/tez/

hdfs dfs -put /opt/tmp_libs/* /hadoop/apps/tez/
hdfs dfs -chown -R $HDFS_USER:$HADOOP_USER /hadoop
hadoop fs -chmod g+w /hadoop/apps/tez
hadoop fs -chmod g+w /hadoop/apps/tez/*

cd $HIVE_HOME/bin
./hiveserver2 --hiveconf hive.server2.enable.doAs=false
