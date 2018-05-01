ARG tag="latest"
ARG registry="registry.oc.univie.ac.at"
ARG nodeprefix="amc/opencast-mt"
FROM registry.oc.univie.ac.at/${nodeprefix}-source:${tag} AS builder
ENV OPENCAST_DISTRIBUTION="admin"
RUN cd "${OPENCAST_TAR}" && \
    tar -xzf opencast-dist-"${OPENCAST_DISTRIBUTION}"-*.tar.gz --strip 1 -C "${OPENCAST_BUILD}"

# Build image for Opencast node
FROM registry.oc.univie.ac.at/${nodeprefix}-base:${tag}
ARG ORG_OPENCASTPROJECT_SERVER_URL="oc-admin"
ENV ORG_OPENCASTPROJECT_SERVER_URL=$ORG_OPENCASTPROJECT_SERVER_URL
COPY --from=builder "${OPENCAST_BUILD}" "${OPENCAST_HOME}"
RUN cp -R ${OPENCAST_HOME}/etc-temp/* "${OPENCAST_CONFIG}/" && \
    rm -rf ${OPENCAST_HOME}/etc-temp/
RUN chown -R "${OPENCAST_USER}:${OPENCAST_GROUP}" "${OPENCAST_DATA}" && \
    chown -R "${OPENCAST_USER}:${OPENCAST_GROUP}" "${OPENCAST_HOME}" && \
    chown -R "${OPENCAST_USER}:${OPENCAST_GROUP}" /docker-*.sh
RUN  javac "${OPENCAST_SCRIPTS}/TryToConnectToDb.java"
EXPOSE 8080
VOLUME [ "${OPENCAST_DATA}", "${OPENCAST_CONFIG}", "${OPENCAST_HOME}/deploy" ]
WORKDIR "${OPENCAST_HOME}"
HEALTHCHECK --timeout=10s CMD /docker-healthcheck.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["app:start"]
