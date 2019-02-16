FROM alpine:latest

ARG USER=core
ARG USER_UID=500
ARG USER_GID=500
ARG DOCKER_GID=233

ARG DOCKER_VERSION=18.09.1
ARG CT_VERSION=0.9.0
ARG FZF_VERSION=0.17.5
ARG Z_VERSION=1.11

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
      zsh-vcs && \
    apk add --no-cache docker-compose --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing

# Create user with permissions to docker and sudo
RUN groupadd --gid ${DOCKER_GID} docker && \
    groupadd --gid ${USER_GID} ${USER} && \
    useradd --uid ${USER_UID} --gid ${USER_GID} --groups docker --shell /bin/zsh --comment 'CoreOS Admin' core && \
    echo "${USER} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Install bat and exa
RUN apk add --no-cache --virtual .build-deps build-base cmake go cargo && \
    cargo install --root /usr/local bat exa && \
    rm -rf ${HOME}/.cargo && \
    apk del .build-deps

# Install docker CLI
RUN curl -fsSLO https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz && \
    tar xzvf docker-${DOCKER_VERSION}.tgz --strip 1 -C /usr/local/bin docker/docker && \
    rm docker-${DOCKER_VERSION}.tgz && \
# Install CoreOS Config Transpiler (ct)
    curl -fsSL https://github.com/coreos/container-linux-config-transpiler/releases/download/v${CT_VERSION}/ct-v${CT_VERSION}-x86_64-unknown-linux-gnu -o /usr/local/bin/ct && \
    chmod a+x /usr/local/bin/ct &&\
# Install z.sh
    curl -fsSLO https://github.com/rupa/z/archive/v${Z_VERSION}.tar.gz && \
    tar zxvf v${Z_VERSION}.tar.gz --strip 1 -C /usr/local/bin z-${Z_VERSION}/z.sh && \
    rm v${Z_VERSION}.tar.gz && \
# Install fzf
    curl -fsSLO https://github.com/junegunn/fzf-bin/releases/download/${FZF_VERSION}/fzf-${FZF_VERSION}-linux_amd64.tgz && \
    tar zxvf fzf-${FZF_VERSION}-linux_amd64.tgz -C /usr/local/bin && \
    rm fzf-${FZF_VERSION}-linux_amd64.tgz && \
# Install oh-my-zsh
    git clone https://github.com/robbyrussell/oh-my-zsh.git ${HOME}/.oh-my-zsh

COPY files/home/ ${HOME}/

RUN chown -R ${USER_UID}:${USER_GID} ${HOME}

WORKDIR ${HOME}

USER ${USER}

CMD ["/bin/zsh"]
