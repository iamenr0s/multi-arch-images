FROM almalinux/9-base
LABEL maintainer="iamenr0s"

ARG BUILD_DATE
LABEL build_date=$BUILD_DATE

WORKDIR /github/workspace
COPY requirements.txt .
RUN dnf update -y && \
    dnf group install -y "Development Tools" && \
    dnf install -y python3-pip podman jq && \
    python3 -m venv /opt/venv && \
    /opt/venv/bin/python3 -m pip install --upgrade pip && \
    /opt/venv/bin/pip3 install --no-cache-dir -r requirements.txt && \
    /opt/venv/bin/python -m pip cache purge && \
    sudo mount --make-rshared /

ENV PATH=/opt/venv/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
COPY cmd.sh /cmd.sh
RUN chmod 777 /cmd.sh
CMD ["/cmd.sh"]
