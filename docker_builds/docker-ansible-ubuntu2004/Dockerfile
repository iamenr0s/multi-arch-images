FROM ubuntu:20.04

LABEL maintainer="enr0s"

ENV ANSIBLE_DOCKER_VERSION 0.1.0
ENV PIP_PACKAGES "ansible==2.9.9"
ENV DEBIAN_FRONTEND "noninteractive"
ENV CRYPTOGRAPHY_DONT_BUILD_RUST=1

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
       apt-utils \
       locales \
       build-essential \
       python3-setuptools \
       python3-pip \
       libssl-dev libffi-dev python3-dev cargo\
       software-properties-common \
       rsyslog systemd systemd-cron sudo iproute2 \
    && rm -Rf /var/lib/apt/lists/* \
    && rm -Rf /usr/share/doc && rm -Rf /usr/share/man \
    && apt-get clean
RUN sed -i 's/^\($ModLoad imklog\)/#\1/' /etc/rsyslog.conf
RUN locale-gen en_GB.UTF-8
RUN python3 -m pip install --upgrade pip setuptools wheel && pip install ${PIP_PACKAGES}
RUN mkdir -p /etc/ansible
RUN echo "[local]\nlocalhost ansible_connection=local" > /etc/ansible/hosts
RUN rm -f /lib/systemd/system/systemd*udev* && rm -f /lib/systemd/system/getty.target

VOLUME ["/sys/fs/cgroup", "/tmp", "/run"]
CMD ["/lib/systemd/systemd"]
