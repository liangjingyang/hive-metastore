#!/bin/sh

export HADOOP_HOME=/opt/hadoop-3.2.0
export HIVE_HOME=/opt/apache-hive-metastore-3.0.0-bin
export LOG4J_VERSION=2.17.0
export HADOOP_CLASSPATH=${HADOOP_HOME}/share/hadoop/tools/lib/aws-java-sdk-bundle-1.11.375.jar:${HADOOP_HOME}/share/hadoop/tools/lib/hadoop-aws-3.2.0.jar:${HIVE_HOME}/lib/log4j-core-${LOG4J_VERSION}.jar:${HIVE_HOME}/lib/log4j-api-${LOG4J_VERSION}.jar:${HIVE_HOME}/lib/log4j-1.2-api-${LOG4J_VERSION}.jar:${HIVE_HOME}/lib/log4j-slf4j-impl-${LOG4J_VERSION}.jar
export JAVA_HOME=/usr/local/openjdk-8

echo "Waiting for database on postgres to launch on 5432 ..."

while ! nc -z postgres 5432; do
  sleep 1
done

echo "Database on postgres:5432 started"
echo "Init apache hive metastore on postgres:5432"

${HIVE_HOME}/bin/schematool -initSchema -dbType postgres
${HIVE_HOME}/bin/start-metastore
