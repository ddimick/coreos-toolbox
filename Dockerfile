# Set the base image to Ubuntu Server
FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive
ENV HOME=/home/core
ENV TZ=America/Los_Angeles
ENV DOCKERCOMPOSE_VERSION=1.23.0

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y zsh zsh-common git git-core tmux sed curl wget \
        sudo net-tools inetutils-ping bash-completion openssh-client vim \
        gcc make autoconf tzdata locales docker.io && \
    locale-gen en_US.UTF-8 && \
  # docker-compose
    curl -L https://github.com/docker/compose/releases/download/${DOCKERCOMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose && \
  # user/group creation
    groupadd --gid 500 core && \
    groupmod --gid 233 docker && \
    useradd --home-dir /home/core --uid 500 --gid 500 --groups docker --comment 'CoreOS Admin' -s /bin/zsh core && \
    echo "core ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
  # oh-my-zsh
    curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | zsh || true && \
    rm -R ~/.oh-my-zsh/plugins/last-working-dir && \
  # cleanup
    apt-get clean && \
    rm -rf /var/lib/apt

COPY config-files/.* $HOME/
COPY ohmyzsh-files/custom.zsh-theme $HOME/.oh-my-zsh/custom/themes/

RUN chown -R core:core $HOME

ENV DEBIAN_FRONTEND=teletype

WORKDIR $HOME

USER core

CMD ["/bin/zsh"]

