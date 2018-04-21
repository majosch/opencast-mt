# Untar distribution files and pull configuration from repo

ARG tag

FROM opencast-source:${tag} AS builder

ENV OPENCAST_DISTRIBUTION="worker"


RUN cd "${OPENCAST_TAR}" && \
    tar -xzf opencast-dist-"${OPENCAST_DISTRIBUTION}"-*.tar.gz --strip 1 -C "${OPENCAST_BUILD}"

#WORKDIR "${OPENCAST_HOME}"

#RUN git clone "${OPENCAST_CONFIG_GIT}" config

#RUN cp -r config/"${OPENCAST_DISTRIBUTION}"/etc/* "${OPENCAST_HOME}"/etc/ && \
#    cd "${OPENCAST_HOME}" && \
#    rm -rf config/

# Build image for Opencast node

FROM opencast-base:${tag}
ARG ORG_OPENCASTPROJECT_SERVER_URL="oc-worker"
ENV ORG_OPENCASTPROJECT_SERVER_URL=$ORG_OPENCASTPROJECT_SERVER_URL
COPY --from=builder "${OPENCAST_BUILD}" "${OPENCAST_HOME}"

RUN cp -R ${OPENCAST_HOME}/etc-temp/* "${OPENCAST_CONFIG}/" && \
    rm -rf ${OPENCAST_HOME}/etc-temp/

RUN chown -R "${OPENCAST_USER}:${OPENCAST_GROUP}" "${OPENCAST_DATA}" && \
    chown -R "${OPENCAST_USER}:${OPENCAST_GROUP}" "${OPENCAST_HOME}"

RUN  javac "${OPENCAST_SCRIPTS}/TryToConnectToDb.java"

EXPOSE 8080

VOLUME [ "${OPENCAST_DATA}", "${OPENCAST_CONFIG}", "${OPENCAST_HOME}/deploy" ]

#USER "${OPENCAST_USER}":"${OPENCAST_GROUP}"

WORKDIR "${OPENCAST_HOME}"

#HEALTHCHECK --timeout=10s CMD /docker-healthcheck.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["app:start"]
