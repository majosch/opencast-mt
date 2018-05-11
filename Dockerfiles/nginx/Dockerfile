FROM nginx:alpine
ARG SERVERNAME="indifferent.ibis.oc.unive.ac.at"
ENV SERVERNAME=$SERVERNAME
RUN apk update && \
    apk add \
      nano

RUN rm /etc/nginx/conf.d/*
RUN mkdir -p /data
COPY assets/nginx.conf /etc/nginx/
COPY assets/opencast.conf /etc/nginx/conf.d
COPY assets/docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["app:start"]
