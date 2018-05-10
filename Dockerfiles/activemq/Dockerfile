ARG tag="5.x"
ARG registry="registry.oc.univie.ac.at"
ARG nodeprefix="amc/opencast-mt"
FROM ${registry}/${nodeprefix}-source:${tag} AS builder
ENV LANG="C.UTF-8" \
    OPENCAST_USER="opencast" \
    OPENCAST_GROUP="opencast" \
    OPENCAST_UID="800" \
    OPENCAST_GID="800" \
    OPENCAST_TAR="/tar" \
    OPENCAST_DATA="/data" \
    OPENCAST_HOME="/opencast" \
    MARIADB_BASEVERSION="10.0" \
    OPENCAST_DB_DDL="${OPENCAST_BUILD}/ddl"

FROM openjdk:7
ARG ACTIVEMQ_VERSION="5.13.2"
ARG ACTIVEMQ_BROKER_USERNAME="opencast"
ARG ACTIVEMQ_BROKER_PASSWORD="opencast"
ENV ACTIVEMQ_VERSION=$ACTIVEMQ_VERSION
ENV ACTIVEMQ apache-activemq-$ACTIVEMQ_VERSION
ENV ACTIVEMQ_TCP=61616 ACTIVEMQ_AMQP=5672 ACTIVEMQ_STOMP=61613 ACTIVEMQ_MQTT=1883 ACTIVEMQ_WS=61614 ACTIVEMQ_UI=8161
ENV ACTIVEMQ_HOME="/opt/activemq"
ENV ACTIVEMQ_BROKER_USERNAME=$ACTIVEMQ_BROKER_USERNAME \
    ACTIVEMQ_BROKER_PASSWORD=$ACTIVEMQ_BROKER_PASSWORD
ENV OPENCAST_TAR="/tar"
ENV OPENCAST_AMQ_XML="${OPENCAST_TAR}/amq"
RUN curl -O http://archive.apache.org/dist/activemq/$ACTIVEMQ_VERSION/$ACTIVEMQ-bin.tar.gz && \
    mkdir -p /opt && \
    tar xf $ACTIVEMQ-bin.tar.gz -C /opt/ && \
    rm $ACTIVEMQ-bin.tar.gz && \
    ln -s /opt/$ACTIVEMQ $ACTIVEMQ_HOME && \
    useradd -r -M -d $ACTIVEMQ_HOME activemq && \
    chown -R activemq:activemq /opt/$ACTIVEMQ
COPY assets/conf/* /opt/activemq/conf/
COPY --from=builder "${OPENCAST_AMQ_XML}"/* /opt/activemq/conf/
RUN mkdir -p /opt/scripts
COPY assets/scripts/* /opt/scripts/
RUN chown -R activemq:activemq /opt/scripts/
COPY assets/docker-entrypoint.sh /
USER activemq

WORKDIR $ACTIVEMQ_HOME
EXPOSE $ACTIVEMQ_TCP $ACTIVEMQ_AMQP $ACTIVEMQ_STOMP $ACTIVEMQ_MQTT $ACTIVEMQ_WS $ACTIVEMQ_UI
VOLUME [ "/opt/activemq/conf" ]
#CMD cat conf/users.properties && cat conf/groups.properties

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["app:start"]
