# Set the base image to Ubuntu Server
FROM alpine:latest

ARG USER=core
ARG USER_UID=500
ARG USER_GID=500
ARG DOCKER_GID=233

ENV DOCKERCOMPOSE_VERSION=1.23.0
ENV CT_VER=v0.6.1

ENV HOME=/home/${USER}

# Package installation
RUN apk add --no-cache \
      shadow \
      docker \
      py-pip \
      sudo \
      openssh-client \
      findutils \
      git \
      zsh \
      tzdata \
      docker-zsh-completion \
      git-zsh-completion \
      rsync-zsh-completion \
      tmux-zsh-completion \
      zsh-vcs \
      tmux \
      curl \
      vim \
      docker-vim \
      htop \
      rsync && \
    apk add --no-cache --virtual .build-dependencies py-pip && \
    pip install --disable-pip-version-check --no-cache-dir docker-compose && \
    apk del .build-dependencies && \
# User and group creation
    groupmod --gid ${DOCKER_GID} docker && \
    groupadd --gid ${USER_GID} ${USER} && \
    useradd --uid ${USER_UID} --gid ${USER_GID} --groups docker --shell /bin/zsh --comment 'CoreOS Admin' core && \
    echo "core ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
# Install CoreOS cloud-config.yaml to ignition.json Config Transpiler
    curl -LSs https://github.com/coreos/container-linux-config-transpiler/releases/download/${CT_VER}/ct-${CT_VER}-x86_64-unknown-linux-gnu -o /usr/local/bin/ct && \
    chmod +x /usr/local/bin/ct && \
# Install oh-my-zsh
    curl -LSs https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | zsh || true

COPY files/ ${HOME}/

RUN chown -R ${USER_UID}:${USER_GID} ${HOME}

WORKDIR ${HOME}

USER ${USER}

CMD ["/bin/zsh"]
