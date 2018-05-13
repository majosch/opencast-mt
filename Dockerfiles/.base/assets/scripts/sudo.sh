#!/bin/bash
#adduser "${OPENCAST_USER}" wheel
echo '{{OPENCAST_USER}} ALL=(ALL) NOPASSWD: /docker-entrypoint.sh' >> /etc/sudoers
sed -i -e "s/{{OPENCAST_USER}}/$(echo $OPENCAST_USER)/g" /etc/sudoers
#su -m "${OPENCAST_USER}" -c /docker-entrypoint.sh
