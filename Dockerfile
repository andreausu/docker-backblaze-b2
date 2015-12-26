FROM python:2.7-slim

MAINTAINER Andrea Usuelli <andreausu@gmail.com>

# 0.3.9 Unfortunately releases are not yet tagged on GitHub
ENV VERSION=0a0c5d0a4fb2e7f005f4dc4341d6d0512489e227

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

ENTRYPOINT [ "/usr/bin/b2" ]
