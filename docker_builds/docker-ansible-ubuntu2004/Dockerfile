FROM ubuntu:20.04

LABEL maintainer="iamenr0s"

ENV PIP_PACKAGES "cryptography==2.9.2 ansible"
ENV DEBIAN_FRONTEND "noninteractive"

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       apt-utils \
       locales \
       build-essential \
       python3-setuptools \
       python3-pip \
       libssl-dev \
       libffi-dev \
       libyaml-dev \
       python3-dev \
       python3-yaml \
       cargo \
       software-properties-common \
       rsyslog systemd systemd-cron sudo iproute2 \
    && rm -Rf /var/lib/apt/lists/* \
    && rm -Rf /usr/share/doc && rm -Rf /usr/share/man \
    && apt-get clean
RUN sed -i 's/^\($ModLoad imklog\)/#\1/' /etc/rsyslog.conf
RUN locale-gen en_GB.UTF-8
RUN pip install ${PIP_PACKAGES}
RUN mkdir -p /etc/ansible
RUN echo "[local]\nlocalhost ansible_connection=local" > /etc/ansible/hosts
RUN rm -f /lib/systemd/system/systemd*udev* && rm -f /lib/systemd/system/getty.target

VOLUME ["/sys/fs/cgroup", "/tmp", "/run"]
CMD ["/lib/systemd/systemd"]
