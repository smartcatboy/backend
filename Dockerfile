FROM python:3.8

ARG BACKEND_APP_VERSION=dev
ENV BACKEND_VERSION=$BACKEND_APP_VERSION

WORKDIR /

RUN apt update && \
    apt install -y openssh-client sshpass git wget

RUN sed -i '/#   StrictHostKeyChecking /c StrictHostKeyChecking no' /etc/ssh/ssh_config && \
    sed -i 's/^#\s\+UserKnownHostsFile.*/UserKnownHostsFile \/dev\/null/' /etc/ssh/ssh_config

RUN COMMIT_ID=$(git clone -q https://github.com/smartcatboy/compose.git /tmp/compose && \
    cd /tmp/compose && git checkout -q tags/$BACKEND_VERSION && \
    git ls-files -s backend | grep -w backend$ | awk '{print $2}') && \
    git clone --branch main https://github.com/smartcatboy/backend.git /app && \
    cd /app && git reset --hard $COMMIT_ID && rm -rf /tmp/compose

WORKDIR /app
RUN pip install --no-cache-dir -r requirements.txt
