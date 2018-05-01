ARG tag="latest"
ARG registry="registry.oc.univie.ac.at"
ARG nodeprefix="amc/opencast-mt"
FROM registry.oc.univie.ac.at/amc/opencast-mt-source:5.x AS builder
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

## TODO: ARG MARIADB_BASEVERSION
FROM mariadb:10.0
ENV OPENCAST_TAR="/tar"
ENV OPENCAST_DB_DDL="${OPENCAST_TAR}/ddl"
COPY --from=builder "${OPENCAST_DB_DDL}"/mysql5.sql /docker-entrypoint-initdb.d/
