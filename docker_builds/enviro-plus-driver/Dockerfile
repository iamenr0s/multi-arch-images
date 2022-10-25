FROM python:3.11-buster

RUN apt update && \
    apt install -y sudo && \
    adduser --disabled-password --gecos 'Sensor Service' sensor && \
    adduser sensor sudo && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER sensor
WORKDIR /home/sensor

RUN git clone https://github.com/pimoroni/enviroplus-python && \
    cd enviroplus-python && \
    sudo ./install.sh


