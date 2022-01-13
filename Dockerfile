FROM python:3.8 AS builder

RUN  wget "https://github.com/giampaolo/psutil/archive/refs/tags/release-5.8.0.tar.gz" -O 5.8.0.tgz && \
     tar zxf 5.8.0.tgz && cd psutil-release-5.8.0/ && \
     python setup.py build bdist_wheel && \
     mv dist/psutil-5.8.0-cp38-cp38-linux_$(uname -m).whl dist/psutil-5.8.0-cp38-cp38-linux.whl

FROM python:3.8-slim

ARG BACKEND_APP_VERSION=dev
ENV BACKEND_VERSION=$BACKEND_APP_VERSION

RUN mkdir /app
WORKDIR /app

RUN apt update -y && \
    apt install -y openssh-client sshpass git wget

RUN sed -i '/#   StrictHostKeyChecking /c StrictHostKeyChecking no' /etc/ssh/ssh_config && \
    sed -i 's/^#\s\+UserKnownHostsFile.*/UserKnownHostsFile \/dev\/null/' /etc/ssh/ssh_config

COPY . ./
COPY --from=builder /psutil-release-5.8.0/dist/psutil-5.8.0-cp38-cp38-linux.whl ./
RUN mv psutil-5.8.0-cp38-cp38-linux.whl psutil-5.8.0-cp38-cp38-linux_$(uname -m).whl && \
    echo psutil-5.8.0-cp38-cp38-linux_$(uname -m).whl >> requirements.txt && \
    pip install --no-cache-dir -r requirements.txt && \
    rm -f psutil-5.8.0-cp38-cp38-linux_$(uname -m).whl
