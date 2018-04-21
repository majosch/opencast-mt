FROM opencast-source:latest AS builder
ENV LANG="C.UTF-8" \
    OPENCAST_USER="opencast" \
    OPENCAST_GROUP="opencast" \
    OPENCAST_UID="800" \
    OPENCAST_GID="800" \
    OPENCAST_SRC="/usr/src/opencast" \
    OPENCAST_DATA="/data" \
    OPENCAST_HOME="/opencast" \
    OPENCAST_BRANCH="4.3" \
#    OPENCAST_CONFIG_GIT="https://schambm7:k3m2zbfe@bitbucket.org/schambm7/oc-univie-config.git" \
    MARIADB_BASEVERSION="10.0"

#    WORKDIR "${OPENCAST_HOME}"
#    RUN git clone "${OPENCAST_CONFIG_GIT}" config
#    RUN cp -n "${OPENCAST_SRC}"/docs/scripts/ddl/mysql5.sql ./config/mariadb/



FROM mariadb:10.0
ENV OPENCAST_SRC="/usr/src/opencast"
COPY --from=builder "${OPENCAST_SRC}"/docs/scripts/ddl/mysql5.sql /docker-entrypoint-initdb.d/
