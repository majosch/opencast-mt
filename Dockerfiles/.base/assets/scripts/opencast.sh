#!/bin/sh
#
# Copyright 2016 The WWU eLectures Team All rights reserved.
#
# Licensed under the Educational Community License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License. You may obtain a copy of the License at
#
#     http://opensource.org/licenses/ECL-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e

export ORG_OPENCASTPROJECT_SERVER_URL="${ORG_OPENCASTPROJECT_SERVER_URL:-$(hostname -f):8080}"
export ORG_OPENCASTPROJECT_SERVER_URL2="${ORG_OPENCASTPROJECT_SERVER_URL2:-$(hostname -f)}"
export ORG_OPENCASTPROJECT_ADMIN_EMAIL="${ORG_OPENCASTPROJECT_ADMIN_EMAIL:-admin@localhost}"
export ORG_OPENCASTPROJECT_DOWNLOAD_URL="${ORG_OPENCASTPROJECT_DOWNLOAD_URL:-\$\{org.opencastproject.server.url\}/static}"

MH_DEFAULT_ORG_SERVER_ADMIN="$(echo $PROP_ORG_OPENCASTPROJECT_ADMIN_UI_URL | cut -d'/' -f 3 | cut -d':' -f 1)"
MH_DEFAULT_ORG_SERVER_PRESENTATION="$(echo $PROP_ORG_OPENCASTPROJECT_ENGAGE_UI_URL | cut -d'/' -f 3 | cut -d':' -f 1)"
TENANT1_SERVER_ADMIN="$(echo $PROP_ORG_OPENCASTPROJECT_TENANT1_ADMIN_UI_URL | cut -d'/' -f 3 | cut -d':' -f 1)"
TENANT1_SERVER_PRESENTATION="$(echo $PROP_ORG_OPENCASTPROJECT_TENANT1_PRESENTATION_UI_URL | cut -d'/' -f 3 | cut -d':' -f 1)"
TENANT2_SERVER_ADMIN="$(echo $PROP_ORG_OPENCASTPROJECT_TENANT2_ADMIN_UI_URL | cut -d'/' -f 3 | cut -d':' -f 1)"
TENANT2_SERVER_PRESENTATION="$(echo $PROP_ORG_OPENCASTPROJECT_TENANT2_PRESENTATION_UI_URL | cut -d'/' -f 3 | cut -d':' -f 1)"

if opencast_helper_dist_allinone || opencast_helper_dist_develop; then
  # shellcheck disable=SC2016
  export PROP_ORG_OPENCASTPROJECT_FILE_REPO_URL="${PROP_ORG_OPENCASTPROJECT_FILE_REPO_URL:-\$\{org.opencastproject.server.url\}}"
  export PROP_ORG_OPENCASTPROJECT_ADMIN_UI_URL="${PROP_ORG_OPENCASTPROJECT_ADMIN_UI_URL:-\$\{org.opencastproject.server.url\}}"
  export PROP_ORG_OPENCASTPROJECT_ENGAGE_UI_URL="${PROP_ORG_OPENCASTPROJECT_ENGAGE_UI_URL:-\$\{org.opencastproject.server.url\}}"

else
  # shellcheck disable=SC2016
  export PROP_ORG_OPENCASTPROJECT_FILE_REPO_URL="${PROP_ORG_OPENCASTPROJECT_FILE_REPO_URL:-\$\{prop.org.opencastproject.admin.ui.url\}}"
fi

if opencast_helper_dist_migration ; then
  export ORG_OPENCASTPROJECT_MIGRATION_ORGANIZATION="${ORG_OPENCASTPROJECT_MIGRATION_ORGANIZATION:-mh_default_org}"
fi

opencast_opencast_check() {
  echo "Run opencast_opencast_check"
  opencast_helper_checkforvariables \
    "ORG_OPENCASTPROJECT_SERVER_URL" \
    "ORG_OPENCASTPROJECT_SECURITY_ADMIN_USER" \
    "ORG_OPENCASTPROJECT_SECURITY_ADMIN_PASS" \
    "ORG_OPENCASTPROJECT_SECURITY_DIGEST_USER" \
    "ORG_OPENCASTPROJECT_SECURITY_DIGEST_PASS" \
    "PROP_ORG_OPENCASTPROJECT_FILE_REPO_URL" \
    "PROP_ORG_OPENCASTPROJECT_ADMIN_UI_URL" \
    "PROP_ORG_OPENCASTPROJECT_ENGAGE_UI_URL"

  if opencast_helper_dist_migration ; then
    opencast_helper_checkforvariables "ORG_OPENCASTPROJECT_MIGRATION_ORGANIZATION"
  fi
}

opencast_opencast_configure() {
  echo "Run opencast_opencast_configure"
  opencast_helper_replaceinfile "${OPENCAST_CONFIG}/custom.properties" \
    "ORG_OPENCASTPROJECT_ADMIN_EMAIL" \
    "ORG_OPENCASTPROJECT_SERVER_URL" \
    "ORG_OPENCASTPROJECT_SECURITY_ADMIN_USER" \
    "ORG_OPENCASTPROJECT_SECURITY_ADMIN_PASS" \
    "ORG_OPENCASTPROJECT_SECURITY_DIGEST_USER" \
    "ORG_OPENCASTPROJECT_SECURITY_DIGEST_PASS" \
    "ORG_OPENCASTPROJECT_DOWNLOAD_URL" \
    "STREAMING_SERVER" \
    "STREAMING_APPLICATION" \
    "STREAMING_SERVER_SCHEME_RTMP" \
    "STREAMING_PORT_RTMP" \
    "STREAMING_SERVER_SCHEME_ADAPTIVE" \
    "STREAMING_PORT_ADAPTIVE"

  opencast_helper_replaceinfile "${OPENCAST_CONFIG}/org.opencastproject.organization-mh_default_org.cfg" \
    "ORG_OPENCASTPROJECT_SERVER_URL2" \
    "PROP_ORG_OPENCASTPROJECT_FILE_REPO_URL" \
    "PROP_ORG_OPENCASTPROJECT_ADMIN_UI_URL" \
    "PROP_ORG_OPENCASTPROJECT_ENGAGE_UI_URL" \
    "MH_DEFAULT_ORG_SERVER_ADMIN" \
    "MH_DEFAULT_ORG_SERVER_PRESENTATION"

  opencast_helper_replaceinfile "${OPENCAST_CONFIG}/org.opencastproject.organization-tenant1.cfg" \
    "PROP_ORG_OPENCASTPROJECT_FILE_REPO_URL" \
    "TENANT1_ID" \
    "TENANT1_NAME" \
    "PROP_ORG_OPENCASTPROJECT_TENANT1_ADMIN_UI_URL" \
    "PROP_ORG_OPENCASTPROJECT_TENANT1_PRESENTATION_UI_URL" \
    "TENANT1_SERVER_ADMIN" \
    "TENANT1_SERVER_PRESENTATION"

  opencast_helper_replaceinfile "${OPENCAST_CONFIG}/org.opencastproject.organization-tenant2.cfg" \
    "PROP_ORG_OPENCASTPROJECT_FILE_REPO_URL" \
    "TENANT2_ID" \
    "TENANT2_NAME" \
    "PROP_ORG_OPENCASTPROJECT_TENANT2_ADMIN_UI_URL" \
    "PROP_ORG_OPENCASTPROJECT_TENANT2_PRESENTATION_UI_URL" \
    "TENANT2_SERVER_ADMIN" \
    "TENANT2_SERVER_PRESENTATION"

  if opencast_helper_dist_migration ; then
    opencast_helper_replaceinfile "${OPENCAST_CONFIG}/custom.properties" "ORG_OPENCASTPROJECT_MIGRATION_ORGANIZATION"
  fi
}
