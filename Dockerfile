FROM alpine:latest

ARG USER=core
ARG USER_UID=500
ARG USER_GID=500
ARG DOCKER_GID=233
ARG DOCKER_VERSION=docker-18.09.1

ENV HOME=/home/${USER}

# Package installation
RUN apk update --no-cache && \
    apk add --no-cache \
      curl \
      docker-vim \
      docker-zsh-completion \
      findutils \
      git \
      git-zsh-completion \
      htop \
      less \
      libgcc \
      openssh-client \
      rsync \
      rsync-zsh-completion \
      shadow \
      sudo \
      tmux \
      tmux-zsh-completion \
      tzdata \
      vim \
      zsh \
      zsh-vcs

# Docker and docker-compose CLI installation
RUN apk add --no-cache docker-compose --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing && \
    curl -fsSLO https://download.docker.com/linux/static/stable/x86_64/${DOCKER_VERSION}.tgz && \
    tar xzvf ${DOCKER_VERSION}.tgz --strip 1 -C /usr/local/bin docker/docker && \
    rm ${DOCKER_VERSION}.tgz &&\
    groupadd --gid ${DOCKER_GID} docker && \
    groupadd --gid ${USER_GID} ${USER} && \
    useradd --uid ${USER_UID} --gid ${USER_GID} --groups docker --shell /bin/zsh --comment 'CoreOS Admin' core && \
    echo "${USER} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Install oh-my-zsh
RUN git clone https://github.com/robbyrussell/oh-my-zsh.git ${HOME}/.oh-my-zsh

COPY files/home/ ${HOME}/
COPY files/bin/ /usr/local/bin/

#RUN apk add --no-cache --virtual .build-deps \
#      build-base cmake go cargo && \
#    cargo install --root /usr/local bat exa && \
#    apk del .build-deps

RUN chown -R ${USER_UID}:${USER_GID} ${HOME}

WORKDIR ${HOME}

USER ${USER}

CMD ["/bin/zsh"]
