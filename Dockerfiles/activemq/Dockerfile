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
RUN curl -O http://archive.apache.org/dist/activemq/$ACTIVEMQ_VERSION/$ACTIVEMQ-bin.tar.gz && \
    mkdir -p /opt && \
    tar xf $ACTIVEMQ-bin.tar.gz -C /opt/ && \
    rm $ACTIVEMQ-bin.tar.gz && \
    ln -s /opt/$ACTIVEMQ $ACTIVEMQ_HOME && \
    useradd -r -M -d $ACTIVEMQ_HOME activemq && \
    chown activemq:activemq /opt/$ACTIVEMQ -R
COPY Dockerfiles/activemq/assets/* /opt/activemq/conf/
RUN sed -i -e "s/{{ACTIVEMQ_BROKER_USERNAME}}/$(echo $ACTIVEMQ_BROKER_USERNAME)/g" ${ACTIVEMQ_HOME}/conf/users.properties && \
    sed -i -e "s/{{ACTIVEMQ_BROKER_PASSWORD}}/$(echo $ACTIVEMQ_BROKER_PASSWORD)/g" ${ACTIVEMQ_HOME}/conf/users.properties && \
    sed -i -e "s/{{ACTIVEMQ_BROKER_USERNAME}}/$(echo $ACTIVEMQ_BROKER_USERNAME)/g" ${ACTIVEMQ_HOME}/conf/groups.properties
USER activemq

WORKDIR $ACTIVEMQ_HOME
EXPOSE $ACTIVEMQ_TCP $ACTIVEMQ_AMQP $ACTIVEMQ_STOMP $ACTIVEMQ_MQTT $ACTIVEMQ_WS $ACTIVEMQ_UI
VOLUME [ "/opt/activemq/conf" ]
#CMD cat conf/users.properties && cat conf/groups.properties
CMD ["/bin/sh", "-c", "bin/activemq console"]
