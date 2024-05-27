FROM registry.fedoraproject.org/fedora:41
LABEL maintainer="iamenr0s"

ARG BUILD_DATE
LABEL build_date=$BUILD_DATE

WORKDIR /github/workspace

COPY requirements.txt .

RUN dnf -y update; yum -y reinstall shadow-utils; \
    yum -y install podman fuse-overlayfs --exclude container-selinux; \
    rm -rf /var/cache /var/log/dnf* /var/log/yum.*; \
    python3 -m venv /opt/venv;  \
    /opt/venv/bin/python3 -m pip install --upgrade pip; \
    /opt/venv/bin/pip3 install --no-cache-dir -r requirements.txt; \
    /opt/venv/bin/python -m pip cache purge 

RUN useradd podman; \ 
    echo podman:10000:5000 > /etc/subuid; \
    echo podman:10000:5000 > /etc/subgid;

VOLUME /var/lib/containers
VOLUME /home/podman/.local/share/containers

ADD https://raw.githubusercontent.com/containers/image_build/main/podman/containers.conf /etc/containers/containers.conf
ADD https://raw.githubusercontent.com/containers/image_build/main/podman/podman-containers.conf /home/podman/.config/containers/containers.conf

RUN chown podman:podman -R /home/podman; \
    chmod 644 /etc/containers/containers.conf; \
    cp /usr/share/containers/storage.conf /etc/containers/storage.conf; \
    sed -i -e 's|^#mount_program|mount_program|g' -e '/additionalimage.*/a "/var/lib/shared",' -e 's|^mountopt[[:space:]]*=.*$|mountopt = "nodev,fsync=0"|g' /etc/containers/storage.conf; \
    mkdir -p /var/lib/shared/overlay-images /var/lib/shared/overlay-layers /var/lib/shared/vfs-images /var/lib/shared/vfs-layers; \touch /var/lib/shared/overlay-images/images.lock; \
    touch /var/lib/shared/overlay-layers/layers.lock; \
    touch /var/lib/shared/vfs-images/images.lock; \
    touch /var/lib/shared/vfs-layers/layers.lock
ENV _CONTAINERS_USERNS_CONFIGURED=""

ENV PATH=/opt/venv/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
COPY cmd.sh /cmd.sh
RUN chmod 777 /cmd.sh
CMD ["/cmd.sh"]
