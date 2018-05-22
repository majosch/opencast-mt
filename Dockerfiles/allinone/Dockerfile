ARG tag="latest"
ARG registry="registry.oc.univie.ac.at"
ARG nodeprefix="amc/opencast-mt"
FROM ${registry}/${nodeprefix}-source:${tag} AS builder
ENV OPENCAST_DISTRIBUTION="allinone"
RUN cd "${OPENCAST_TAR}" && \
    tar -xzf opencast-dist-"${OPENCAST_DISTRIBUTION}"-*.tar.gz --strip 1 -C "${OPENCAST_BUILD}"

# Build image for Opencast node
FROM ${registry}/${nodeprefix}-base:${tag}
ENV OPENCAST_DISTRIBUTION="allinone"
ARG ORG_OPENCASTPROJECT_SERVER_URL="oc-allinone"
ENV ORG_OPENCASTPROJECT_SERVER_URL="$ORG_OPENCASTPROJECT_SERVER_URL"
COPY --from=builder "${OPENCAST_BUILD}" "${OPENCAST_HOME}"
RUN cp -R ${OPENCAST_HOME}/etc-temp/* "${OPENCAST_CONFIG}/" && \
    rm -rf ${OPENCAST_HOME}/etc-temp/
RUN chown -R "${OPENCAST_USER}:${OPENCAST_GROUP}" "${OPENCAST_DATA}" && \
    chown -R "${OPENCAST_USER}:${OPENCAST_GROUP}" "${OPENCAST_HOME}" && \
    chown -R "${OPENCAST_USER}:${OPENCAST_GROUP}" /docker-*.sh
RUN  javac "${OPENCAST_SCRIPTS}/TryToConnectToDb.java"
COPY assets/etc/* "${OPENCAST_CONFIG}/"
EXPOSE 8080
VOLUME [ "${OPENCAST_DATA}", "${OPENCAST_CONFIG}", "${OPENCAST_HOME}/deploy" ]
WORKDIR "${OPENCAST_HOME}"
HEALTHCHECK --timeout=10s CMD /docker-healthcheck.sh
USER ${OPENCAST_USER}
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["app:start"]
