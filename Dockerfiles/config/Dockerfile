FROM debian:stretch
ENV LANG="C.UTF-8" \
    OPENCAST_USER="opencast" \
    OPENCAST_GROUP="opencast" \
    OPENCAST_UID="800" \
    OPENCAST_GID="800" \
    OPENCAST_DATA="/data" \
    OPENCAST_HOME="/opt/opencast"

RUN apt-get update && \
    apt-get -y dist-upgrade && \
    apt -y install \
        tar gzip bzip2 unzip \
        nano bash-completion \
        openssh-server sudo net-tools

RUN mkdir /var/run/sshd && chmod 0755 /var/run/sshd
RUN echo 'root:livestream' | chpasswd

RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

RUN addgroup --gid "${OPENCAST_GID}" "${OPENCAST_GROUP}" && \
    adduser --disabled-password --ingroup "${OPENCAST_GROUP}" --home "${OPENCAST_HOME}" --uid "${OPENCAST_UID}" "${OPENCAST_USER}" && \
    adduser "${OPENCAST_USER}" sudo && \
    adduser "${OPENCAST_USER}" users && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
#RUN echo 'opencast:livestream' | chpasswd

RUN mkdir -p "${OPENCAST_HOME}"/etc/admin && \
    mkdir -p "${OPENCAST_HOME}"/etc/presentation && \
    mkdir -p "${OPENCAST_HOME}"/etc/worker && \
    mkdir -p "${OPENCAST_HOME}"/deploy/admin && \
    mkdir -p "${OPENCAST_HOME}"/deploy/presentation && \
    mkdir -p "${OPENCAST_HOME}"/deploy/worker && \
    mkdir -p "${OPENCAST_HOME}"/db && \
    mkdir -p "${OPENCAST_HOME}"/activemq && \
    mkdir -p "${OPENCAST_HOME}"/.ssh && \
    mkdir -p "${OPENCAST_DATA}" && \
    chown -R "${OPENCAST_USER}:${OPENCAST_GROUP}" "${OPENCAST_HOME}" "${OPENCAST_DATA}" && \
    chown -R "${OPENCAST_USER}:${OPENCAST_GROUP}" "${OPENCAST_HOME}"/.ssh
    #chmod 700 "${OPENCAST_HOME}"/.ssh

WORKDIR "${OPENCAST_HOME}"
VOLUME [ "${OPENCAST_DATA}", "${OPENCAST_HOME}" ]
EXPOSE 22
USER opencast
CMD ["sudo", "/usr/sbin/sshd", "-D"]
#CMD ["/usr/sbin/sshd", "-D"]
