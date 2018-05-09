#!/bin/sh

set -e

# shellcheck source=./scripts/tz.sh
#. "${OPENCAST_SCRIPTS}/tz.sh"


activemq_main_init() {
  echo "Run activemq_main_init"

#  activemq_tz_set
  sed -i -e "s/{{ACTIVEMQ_BROKER_USERNAME}}/$(echo $ACTIVEMQ_BROKER_USERNAME)/g" ${ACTIVEMQ_HOME}/conf/users.properties && \
  sed -i -e "s/{{ACTIVEMQ_BROKER_PASSWORD}}/$(echo $ACTIVEMQ_BROKER_PASSWORD)/g" ${ACTIVEMQ_HOME}/conf/users.properties && \
  sed -i -e "s/{{ACTIVEMQ_BROKER_USERNAME}}/$(echo $ACTIVEMQ_BROKER_USERNAME)/g" ${ACTIVEMQ_HOME}/conf/groups.properties

}

activemq_main_start() {
  echo "Run activemq_main_start"
  cd $ACTIVEMQ_HOME
  bin/activemq console
}

case ${1} in
  app:start)
    activemq_main_init
    activemq_main_start
    ;;
  app:help)
    echo "Usage:"
    echo "  app:help                Prints the usage information"
    echo "  app:start               Starts ActiveMQ"
    echo "  [cmd] [args...]         Runs [cmd] with given arguments"
    ;;
  *)
    exec "$@"
    ;;
esac
