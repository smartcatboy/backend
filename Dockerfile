FROM python:3.8-alpine

ARG BACKEND_APP_VERSION=dev
ENV BACKEND_VERSION=$BACKEND_APP_VERSION

RUN mkdir /app
WORKDIR /app
COPY . ./

RUN apk add --no-cache openssh-client sshpass bash

RUN sed -i '/#   StrictHostKeyChecking /c StrictHostKeyChecking no' /etc/ssh/ssh_config && \
    sed -i 's/^#\s\+UserKnownHostsFile.*/UserKnownHostsFile \/dev\/null/' /etc/ssh/ssh_config

RUN apk add --no-cache --virtual .build-deps gcc libc-dev libffi-dev && \
    pip install --no-cache-dir -r requirements.txt && \
    apk del --no-network .build-deps
