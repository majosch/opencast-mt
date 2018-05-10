FROM openjdk:8-jdk-slim-stretch

ARG repo
ARG branch

ENV LANG="C.UTF-8" \
#    JAVA_HOME="/usr/lib/jvm/java-1.8-openjdk" \
#    PATH="$PATH:/usr/lib/jvm/java-1.8-openjdk/jre/bin:/usr/lib/jvm/java-1.8-openjdk/bin" \
    HUNSPELL_BASE_URL="http://download.services.openoffice.org/contrib/dictionaries" \
    OPENCAST_SRC="/usr/src/opencast" \
    OPENCAST_BUILD="/opencast" \
    OPENCAST_TAR="/tar" \
    OPENCAST_UID="800" \
    OPENCAST_GID="800" \
    OPENCAST_REPO="${repo}" \
    OPENCAST_BRANCH="${branch}"
ENV OPENCAST_DB_DDL="${OPENCAST_TAR}/ddl" \
    OPENCAST_AMQ_XML="${OPENCAST_TAR}/amq"

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      tar gzip git \
      ca-certificates openssl \
      maven make gcc g++ libc-dev
RUN mkdir -p "${OPENCAST_SRC}" "${OPENCAST_TAR}" "${OPENCAST_BUILD}" "${OPENCAST_DB_DDL}" "${OPENCAST_AMQ_XML}"
RUN git clone --recursive "${OPENCAST_REPO}" "${OPENCAST_SRC}" && \
    cd "${OPENCAST_SRC}" && \
    git fetch --all && \
    git checkout "${OPENCAST_BRANCH}"
RUN cp "${OPENCAST_SRC}"/docs/scripts/ddl/mysql5.sql "${OPENCAST_DB_DDL}" && \
    cp "${OPENCAST_SRC}"/docs/scripts/activemq/activemq.xml "${OPENCAST_DB_AMQ}"

RUN cd "${OPENCAST_SRC}" && \
    mvn --batch-mode install -DskipTests=true -Dcheckstyle.skip=true -DskipJasmineTests=true && \
    mv "${OPENCAST_SRC}"/build/* "${OPENCAST_TAR}" && \
    rm -rf "${OPENCAST_SRC}" /tmp/* /var/lib/apt/lists/* ~/.m2 ~/.npm ~/.node-gyp /usr/lib/node_modules
WORKDIR "${OPENCAST_TAR}"
VOLUME ["${OPENCAST_TAR}"]
