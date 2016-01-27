FROM python:2.7-slim

MAINTAINER Andrea Usuelli <andreausu@gmail.com>

ENV VERSION=v0.3.10 \
    AUTHORIZATION_FAIL_MAX_RETRIES=3
    #B2_ACCOUNT_ID        if set at runtime, (re)authorization is performed automatically by this docker image
    #B2_APPLICATION_KEY   if set at runtime, (re)authorization is performed automatically by this docker image

RUN cd /opt && \
    apt-get update && \
    apt-get install -y --no-install-recommends git && \
    git clone https://github.com/Backblaze/B2_Command_Line_Tool.git && \
    cd B2_Command_Line_Tool && \
    git checkout ${VERSION} && \
    cd .. && \
    cp B2_Command_Line_Tool/b2 /usr/bin && \
    chmod +x /usr/bin/b2 && \
    apt-get purge -y git && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* /opt/B2_Command_Line_Tool

COPY files/entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
