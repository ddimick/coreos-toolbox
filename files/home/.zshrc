# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Needed so that tmux shows full colors.
export TERM=screen-256color

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="custom"

# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
#DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
#DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
#COMPLETION_WAITING_DOTS="false"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Automatically start a tmux session upon logging in. Set to false by default.
ZSH_TMUX_AUTOSTART="true"

# Only attempt to autostart tmux once. If this is disabled when the previous option is enabled, then tmux will be autostarted every time you source your zsh config files. Set to true by default.
#ZSH_TMUX_AUTOSTART_ONCE = "true"

# When running tmux automatically connect to the currently running tmux session if it exits, otherwise start a new session. Set to true by default.
#ZSH_TMUX_AUTOCONNECT="true"

# Close the terminal session when tmux exits. Set to the value of ZSH_TMUX_AUTOSTART by default.
#ZSH_TMUX_AUTOQUIT="true"

# When running tmux, the variable $TERM is supposed to be set to screen or one of its derivatives. This option will set the default-terminal option of tmux to screen-256color if 256 color terminal support is detected, and screen otherwise. The term values it uses can be overridden by changing the ZSH_TMUX_FIXTERM_WITH_256COLOR and ZSH_TMUX_FIXTERM_WITHOUT_256COLOR variables respectively. Set to true by default.
ZSH_TMUX_FIXTERM="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(sudo tmux git colored-man-pages zsh-syntax-highlighting docker docker-compose systemd)

# User configuration
# export PATH="~/.local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/usr/games:/usr/local/sbin:/usr/local/bin"
# export MANPATH="/usr/local/man:$MANPATH"
export EDITOR='vim'
export PAGER='less'
export BAT_THEME='Monokai Extended'

# This needs to come before any custom aliases.
source $ZSH/oh-my-zsh.sh

# Jump-list cd (i.e. "z foo")
source /usr/local/bin/z.sh

alias cat='bat -p'
alias less='bat -p'
alias more='bat -p'
alias ls='exa -l --group-directories-first --git'
alias df='df -h'
alias du='du -h'
alias vi='vim'

alias compose='export COMPOSE_FILE=`find ${PROJECT_PATH} -maxdepth 2 -type f -name docker-compose.yaml -printf "${PROJECT_PATH}/%P:" | sed "s/:*$//"`; docker-compose'
alias build='export COMPOSE_FILE=`find ${PROJECT_PATH}/build -maxdepth 2 -type f -name docker-compose.yaml -printf "${PROJECT_PATH}/build/%P:" | sed "s/:*$//"`; docker-compose build --pull --compress'
alias push='export COMPOSE_FILE=`find ${PROJECT_PATH}/build -maxdepth 2 -type f -name docker-compose.yaml -printf "${PROJECT_PATH}/build/%P:" | sed "s/:*$//"`; docker-compose push --ignore-push-failures'
alias console='compose exec'
alias log='compose logs -f --tail="100"'

iotest() { sudo dd if=/dev/zero of="$1"/ddfile bs=1M count=256 conv=fdatasync; sudo rm "$1"/ddfile; }
