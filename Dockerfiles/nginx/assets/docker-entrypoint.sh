#!/bin/sh

set -e

# shellcheck source=./scripts/tz.sh
#. "${OPENCAST_SCRIPTS}/tz.sh"


nginx_main_init() {
  echo "Run nginx_main_init"

  sed -i -e "s/{{SERVERNAME}}/$(echo $SERVERNAME)/g" /etc/nginx/conf.d/opencast.conf


}

nginx_main_start() {
  echo "Run nginx_main_start"
  echo "nginx -s reload"
  nginx -g "daemon off;"
}

case ${1} in
  app:start)
    nginx_main_init
    nginx_main_start
    ;;
  app:help)
    echo "Usage:"
    echo "  app:help                Prints the usage information"
    echo "  app:start               Reloads configuration and starts Nginx"
    echo "  [cmd] [args...]         Runs [cmd] with given arguments"
    ;;
  *)
    exec "$@"
    ;;
esac
