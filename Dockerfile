FROM python:3.8

ARG BACKEND_APP_VERSION=dev
ENV BACKEND_VERSION=$BACKEND_APP_VERSION

WORKDIR /

RUN apt update && \
    apt install -y openssh-client sshpass git

RUN sed -i '/#   StrictHostKeyChecking /c StrictHostKeyChecking no' /etc/ssh/ssh_config && \
    sed -i 's/^#\s\+UserKnownHostsFile.*/UserKnownHostsFile \/dev\/null/' /etc/ssh/ssh_config

RUN git clone --branch main --depth 1 https://github.com/smartcatboy/backend.git /app

WORKDIR /app
RUN pip install --no-cache-dir -r requirements.txt
