#!/bin/bash

export version=1.0.0
export hive_version=2.3.2

cd ~/repos/masterarbeit/docker-hive
docker build -t mfisser/hive:${version}-hive${hadoop_version}-for-postgresql-metastore ./
docker push mfisser/hive:${version}-hive${hadoop_version}-for-postgresql-metastore
