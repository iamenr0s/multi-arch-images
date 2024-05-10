FROM python:3-slim
LABEL maintainer="iamenr0s"

ARG BUILD_DATE
LABEL build_date=$BUILD_DATE

WORKDIR /github/workspace
COPY requirements.txt .
RUN apt-get update && apt-get install -y wget gnupg jq curl git ca-certificates && \
    echo 'deb http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/Debian_12/ /' > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list && \
    wget -nv https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable/Debian_10/Release.key -O- |  apt-key add - && \
    apt-get update && apt-get install -y podman && \
    python3 -m venv /opt/venv && \
    /opt/venv/bin/python3 -m pip install --upgrade pip && \
    /opt/venv/bin/pip3 install --no-cache-dir -r requirements.txt && \
    /opt/venv/bin/python -m pip cache purge && \
    echo 'events_logger = "file"' > /etc/containers/libpod.conf

COPY storage.conf /etc/containers/storage.conf
ENV PATH=/opt/venv/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
COPY cmd.sh /cmd.sh
RUN chmod 777 /cmd.sh
CMD ["/cmd.sh"]
