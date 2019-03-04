FROM google/cloud-sdk:alpine as gcloud
FROM alpine:3.9

ARG user=developer
ARG group=developer
ARG home=/home/${user}
ARG uid=1000
ARG gid=1000
ENV HUB_VERSION 2.7.0
ADD ./env/default/.vim/colors/molokai_dark.vim /tmp/colors/molokai_dark.vim
ADD ./env/default/.vim/syntax/groovy.vim /tmp/syntax/groovy.vim
WORKDIR /

# Add developer user
RUN mkdir -p ${home} \
    && addgroup -g ${gid} ${group} \
    && adduser -h ${home} -u ${uid} -G ${group} -s /bin/bash -D ${user}
# Install standard dependencies
RUN apk --no-cache --update add \
       vim \
       grep \
       tar \
       dos2unix \
       shadow \
       gcc \
       libc-dev \
       ca-certificates \
       docker \
       tree \
       jq \
       multitail \
       ngrep \
       nmap \
       unzip \
       wget \
       curl \
       openjdk8 \
       git \
       git-perl \
       git-email \
       tig \
       bash \
       tmux \
       make \
       terraform \
       python \
       py-crcmod \
       libc6-compat \
       openssh-client \
       gnupg \
       openssl \
    # Install hub-cli
    && curl -sL https://github.com/github/hub/releases/download/v${HUB_VERSION}/hub-linux-amd64-${HUB_VERSION}.tgz | tar zx --strip 2 -C /usr/local/bin hub-linux-amd64-${HUB_VERSION}/bin/hub \
    # Setup Docker hack - there must be a better way
    && usermod -a -G docker ${user} \
    && usermod -a -G root ${user} \
    # Configure vi environment
    && mkdir -p /home/${user}/.vim/pack/plugins/start \
    && mkdir -p /home/${user}/.vim/syntax \
    && rm /usr/bin/vi && ln -s /usr/bin/vim /usr/bin/vi \
    && git clone https://github.com/manniwood/vim-buf.git /home/${user}/.vim/pack/plugins/start/vim-buf \
    && mv /tmp/colors /home/${user}/.vim \
    && mv /tmp/syntax /home/${user}/.vim \
    && chown -R ${user}:${group} /home/${user}

COPY --from=gcloud /google-cloud-sdk /usr/local/google-cloud-sdk

# gcloud configurations
ENV PATH /usr/local/google-cloud-sdk/bin:$PATH
RUN ln -s /lib /lib64 \
    && gcloud config set core/disable_usage_reporting true \
    && gcloud config set component_manager/disable_update_check true \
    && gcloud config set metrics/environment github_docker_image

# Install pre-commit (https://pre-commit.com/)
RUN curl -sL https://pre-commit.com/install-local.py | python -
ENV PATH /home/${user}/bin:$PATH

# Setup Environment
USER ${user}
WORKDIR /home/$user/workspace
