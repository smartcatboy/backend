FROM python:3.8-slim

ARG BACKEND_APP_VERSION=dev
ENV BACKEND_VERSION=$BACKEND_APP_VERSION

WORKDIR /

RUN apt update && \
    apt install -y openssh-client sshpass git wget && \
    apt clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN sed -i '/#   StrictHostKeyChecking /c StrictHostKeyChecking no' /etc/ssh/ssh_config && \
    sed -i 's/^#\s\+UserKnownHostsFile.*/UserKnownHostsFile \/dev\/null/' /etc/ssh/ssh_config

RUN git clone --branch dev https://github.com/smartcatboy/backend.git /app

WORKDIR /app

RUN apt update && \
    apt install -y gcc && \
    pip install --no-cache-dir -r requirements.txt && \
    apt remove -y --purge gcc && \
    apt autoremove -y --purge && \
    apt clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
