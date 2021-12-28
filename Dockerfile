FROM openjdk:8u242-jre

WORKDIR /opt

ENV HADOOP_VERSION=3.2.0
ENV METASTORE_VERSION=3.0.0
ENV PSQL_CONN_VERSION=42.3.1

ENV HADOOP_HOME=/opt/hadoop-${HADOOP_VERSION}
ENV HIVE_HOME=/opt/apache-hive-metastore-${METASTORE_VERSION}-bin

 
RUN curl -L https://archive.apache.org/dist/hive/hive-standalone-metastore-${METASTORE_VERSION}/hive-standalone-metastore-${METASTORE_VERSION}-bin.tar.gz | tar zxf - && \
    curl -L https://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz | tar zxf - && \
    curl -L https://jdbc.postgresql.org/download/postgresql-${PSQL_CONN_VERSION}.jar -o postgresql-${PSQL_CONN_VERSION}.jar && \
    cp postgresql-${PSQL_CONN_VERSION}.jar ${HIVE_HOME}/lib/ && \
    rm  postgresql-${PSQL_CONN_VERSION}.jar && \
    rm ${HIVE_HOME}/lib/log4j-*2.8.2.jar && \
    curl -L https://repo1.maven.org/maven2/org/apache/logging/log4j/log4j-core/2.17.0/log4j-core-2.17.0.jar -o ${HIVE_HOME}/lib/log4j-core-2.17.0.jar && \
    curl -L https://repo1.maven.org/maven2/org/apache/logging/log4j/log4j-api/2.17.0/log4j-api-2.17.0.jar -o ${HIVE_HOME}/lib/log4j-api-2.17.0.jar && \
    curl -L https://repo1.maven.org/maven2/org/apache/logging/log4j/log4j-slf4j-impl/2.17.0/log4j-slf4j-impl-2.17.0.jar -o ${HIVE_HOME}/lib/log4j-slf4j-impl-2.17.0.jar && \
    curl -L https://repo1.maven.org/maven2/org/apache/logging/log4j/log4j-1.2-api/2.17.0/log4j-1.2-api-2.17.0.jar -o ${HIVE_HOME}/lib/log4j-1.2-api-2.17.0.jar
    


RUN apt-get update && apt-get install -y netcat

COPY scripts/entrypoint.sh /entrypoint.sh

RUN groupadd -r hive --gid=1000 && \
    useradd -r -g hive --uid=1000 -d ${HIVE_HOME} hive && \
    chown hive:hive -R ${HIVE_HOME} && \
    chown hive:hive /entrypoint.sh && chmod +x /entrypoint.sh

USER hive
EXPOSE 9083

ENTRYPOINT ["sh", "-c", "/entrypoint.sh"]

