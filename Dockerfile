FROM mfisser/hadoop-base:1.0.0-hadoop2.7.6-java8

# Allow buildtime config of HIVE_VERSION
ARG HIVE_VERSION
# Set HIVE_VERSION from arg if provided at build, env if provided at run, or default
# https://docs.docker.com/engine/reference/builder/#using-arg-variables
# https://docs.docker.com/engine/reference/builder/#environment-replacement
ENV HIVE_VERSION=${HIVE_VERSION:-2.3.0}

ENV HIVE_HOME /opt/hive
ENV PATH $HIVE_HOME/bin:$PATH
ENV HADOOP_HOME /opt/hadoop-$HADOOP_VERSION

WORKDIR /opt

#Install Hive and PostgreSQL JDBC
RUN apt-get update && apt-get install -y wget procps && \
	wget https://archive.apache.org/dist/hive/hive-$HIVE_VERSION/apache-hive-$HIVE_VERSION-bin.tar.gz && \
	tar -xzvf apache-hive-$HIVE_VERSION-bin.tar.gz && \
	mv apache-hive-$HIVE_VERSION-bin hive && \
	wget https://jdbc.postgresql.org/download/postgresql-9.4.1212.jar -O $HIVE_HOME/lib/postgresql-jdbc.jar && \
	rm apache-hive-$HIVE_VERSION-bin.tar.gz && \
	apt-get --purge remove -y wget && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*


#Spark should be compiled with Hive to be able to use it
#hive-site.xml should be copied to $SPARK_HOME/conf folder

#Custom configuration goes here
ADD conf/hive-site.xml $HIVE_HOME/conf
ADD conf/beeline-log4j2.properties $HIVE_HOME/conf
ADD conf/hive-env.sh $HIVE_HOME/conf
ADD conf/hive-exec-log4j2.properties $HIVE_HOME/conf
ADD conf/hive-log4j2.properties $HIVE_HOME/conf
ADD conf/ivysettings.xml $HIVE_HOME/conf
ADD conf/llap-daemon-log4j2.properties $HIVE_HOME/conf
ADD conf/yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml

ENV HADOOP_CLASSPATH=$TEZ_CONF_DIR
ENV HADOOP_CLASSPATH=$HADOOP_CLASSPATH:/opt/tez/hadoop-shim-0.9.0.jar
ENV HADOOP_CLASSPATH=$HADOOP_CLASSPATH:/opt/tez/hadoop-shim-2.6-0.9.0.jar
ENV HADOOP_CLASSPATH=$HADOOP_CLASSPATH:/opt/tez/tez-api-0.9.0.jar
ENV HADOOP_CLASSPATH=$HADOOP_CLASSPATH:/opt/tez/tez-common-0.9.0.jar
ENV HADOOP_CLASSPATH=$HADOOP_CLASSPATH:/opt/tez/tez-dag-0.9.0.jar
ENV HADOOP_CLASSPATH=$HADOOP_CLASSPATH:/opt/tez/tez-examples-0.9.0.jar
ENV HADOOP_CLASSPATH=$HADOOP_CLASSPATH:/opt/tez/tez-ext-service-tests-0.9.0.jar
ENV HADOOP_CLASSPATH=$HADOOP_CLASSPATH:/opt/tez/tez-history-parser-0.9.0.jar
ENV HADOOP_CLASSPATH=$HADOOP_CLASSPATH:/opt/tez/tez-javadoc-tools-0.9.0.jar
ENV HADOOP_CLASSPATH=$HADOOP_CLASSPATH:/opt/tez/tez-job-analyzer-0.9.0.jar
ENV HADOOP_CLASSPATH=$HADOOP_CLASSPATH:/opt/tez/tez-mapreduce-0.9.0.jar
ENV HADOOP_CLASSPATH=$HADOOP_CLASSPATH:/opt/tez/tez-runtime-internals-0.9.0.jar
ENV HADOOP_CLASSPATH=$HADOOP_CLASSPATH:/opt/tez/tez-runtime-library-0.9.0.jar
ENV HADOOP_CLASSPATH=$HADOOP_CLASSPATH:/opt/tez/tez-tests-0.9.0.jar
ENV HADOOP_CLASSPATH=$HADOOP_CLASSPATH:/opt/tez/tez-yarn-timeline-history-0.9.0.jar
ENV HADOOP_CLASSPATH=$HADOOP_CLASSPATH:/opt/tez/tez-yarn-timeline-history-with-acls-0.9.0.jar
ENV HADOOP_CLASSPATH=$HADOOP_CLASSPATH:/opt/tez/lib/RoaringBitmap-0.4.9.jar
ENV HADOOP_CLASSPATH=$HADOOP_CLASSPATH:/opt/tez/lib/async-http-client-1.8.16.jar
ENV HADOOP_CLASSPATH=$HADOOP_CLASSPATH:/opt/tez/lib/commons-cli-1.2.jar
ENV HADOOP_CLASSPATH=$HADOOP_CLASSPATH:/opt/tez/lib/commons-codec-1.4.jar
ENV HADOOP_CLASSPATH=$HADOOP_CLASSPATH:/opt/tez/lib/commons-collections-3.2.2.jar
ENV HADOOP_CLASSPATH=$HADOOP_CLASSPATH:/opt/tez/lib/commons-collections4-4.1.jar
ENV HADOOP_CLASSPATH=$HADOOP_CLASSPATH:/opt/tez/lib/commons-io-2.4.jar
ENV HADOOP_CLASSPATH=$HADOOP_CLASSPATH:/opt/tez/lib/commons-lang-2.6.jar
ENV HADOOP_CLASSPATH=$HADOOP_CLASSPATH:/opt/tez/lib/commons-math3-3.1.1.jar
ENV HADOOP_CLASSPATH=$HADOOP_CLASSPATH:/opt/tez/lib/guava-11.0.2.jar
ENV HADOOP_CLASSPATH=$HADOOP_CLASSPATH:/opt/tez/lib/hadoop-mapreduce-client-common-2.6.0.jar
ENV HADOOP_CLASSPATH=$HADOOP_CLASSPATH:/opt/tez/lib/hadoop-mapreduce-client-core-2.6.0.jar
ENV HADOOP_CLASSPATH=$HADOOP_CLASSPATH:/opt/tez/lib/jersey-client-1.9.jar
ENV HADOOP_CLASSPATH=$HADOOP_CLASSPATH:/opt/tez/lib/jersey-json-1.9.jar
ENV HADOOP_CLASSPATH=$HADOOP_CLASSPATH:/opt/tez/lib/jettison-1.3.4.jar
ENV HADOOP_CLASSPATH=$HADOOP_CLASSPATH:/opt/tez/lib/jetty-6.1.26.jar
ENV HADOOP_CLASSPATH=$HADOOP_CLASSPATH:/opt/tez/lib/jetty-util-6.1.26.jar
ENV HADOOP_CLASSPATH=$HADOOP_CLASSPATH:/opt/tez/lib/jsr305-3.0.0.jar
ENV HADOOP_CLASSPATH=$HADOOP_CLASSPATH:/opt/tez/lib/metrics-core-3.1.0.jar
ENV HADOOP_CLASSPATH=$HADOOP_CLASSPATH:/opt/tez/lib/protobuf-java-2.5.0.jar
ENV HADOOP_CLASSPATH=$HADOOP_CLASSPATH:/opt/tez/lib/servlet-api-2.5.jar
ENV HADOOP_CLASSPATH=$HADOOP_CLASSPATH:/opt/tez/lib/slf4j-api-1.7.10.jar
ENV HADOOP_CLASSPATH=$HADOOP_CLASSPATH:/opt/tez/lib/slf4j-log4j12-1.7.10.jar

COPY startup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/startup.sh

COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 10000
EXPOSE 10002

ENTRYPOINT ["entrypoint.sh"]
CMD startup.sh
