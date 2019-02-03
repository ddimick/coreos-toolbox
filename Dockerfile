FROM alpine:latest

ARG USER=core
ARG USER_UID=500
ARG USER_GID=500
ARG DOCKER_GID=233

ENV HOME=/home/${USER}

# Package installation
RUN apk update --no-cache && \
    apk add --no-cache \
      curl \
      docker \
      docker-vim \
      docker-zsh-completion \
      findutils \
      git \
      git-zsh-completion \
      htop \
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
      zsh-vcs && \
    apk add --no-cache docker-compose --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing && \
    rm -rf /var/cache/apk/* && \
# Install oh-my-zsh
    git clone https://github.com/robbyrussell/oh-my-zsh.git ${HOME}/.oh-my-zsh && \
# User and group creation
    groupmod --gid ${DOCKER_GID} docker && \
    groupadd --gid ${USER_GID} ${USER} && \
    useradd --uid ${USER_UID} --gid ${USER_GID} --groups docker --shell /bin/zsh --comment 'CoreOS Admin' core && \
    echo "${USER} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

COPY files/home/ ${HOME}/
COPY files/bin/ /usr/local/bin/

RUN chown -R ${USER_UID}:${USER_GID} ${HOME}

WORKDIR ${HOME}

USER ${USER}

CMD ["/bin/zsh"]
