FROM alpine:3.19
LABEL maintainer="iamenr0s"

ARG BUILD_DATE
LABEL build_date=$BUILD_DATE

WORKDIR /github/workspace

COPY requirements.txt .

RUN apk add --no-cache \
    build-base \
    gcc \
    curl \
    git \
    jq \
    libffi-dev \
    python3 \
    python3-dev \
    py3-jmespath \     
    py3-pip \
    py3-setuptools \
    py3-wheel \
    podman &&
    rm -rf /var/cache/apk/* &&   
    python3 -m venv /opt/venv &&
    /opt/venv/bin/pip3 install --no-cache-dir -r requirements.txt &&
    /opt/venv/bin/python -m pip cache purge


ENV PATH=/opt/venv/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

COPY cmd.sh /cmd.sh

CMD ["/bin/sh" "-c" "/cmd.sh"]
