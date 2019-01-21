# coreos-toolbox
The standard shell environment provided by CoreOS is rudimentary by design. Administration should happen within a toolbox container. This is an example of one, built with the tools I use on a regular basis. It does *not* use the CoreOS built-in toolbox command because (1) I rarely want to be root within the toolbox and (2) I always want the toolbox container running in the background on the host, so that I may detach and then reattach later without losing my session state. Thus, this container is meant to be run as a service within the CoreOS systemd framework. Once the service is running, it may be accessed at any time with `docker exec -it coreos-toolbox.service zsh`.

### /etc/systemd/system/coreos-toolbox.service
    [Unit]
    Description=CoreOS Toolbox
    After=docker.service
    Requires=docker.service
    
    [Service]
    User=core
    Group=core
    TimeoutStartSec=0
    Restart=always
    ExecStartPre=-/usr/bin/docker kill %n
    ExecStartPre=-/usr/bin/docker rm %n
    ExecStartPre=-/usr/bin/docker pull ddimick/coreos-toolbox:latest
    ExecStart=/usr/bin/docker run --rm --name %n --hostname %H --pid=host \
      -e TZ=America/Los_Angeles \
      -e USER=core \
      -e USER_UID=500 \
      -e USER_GID=500 \
      -v /:/media/root \
      -v /home/core/.git:/home/core/.git \
      -v /home/core/.gitconfig:/home/core/.gitconfig \
      -v /home/core/.ssh:/home/core/.ssh \
      -v /home/core/.zsh_history:/home/core/.zsh_history \
      -v /mnt:/mnt \
      -v /var/run/docker.sock:/var/run/docker.sock ddimick/coreos-toolbox tail -f /dev/null
    
    [Install]
    WantedBy=multi-user.target

## Environment
The image is based on Alpine, using zsh as the default shell, within a tmux session. Other things I find useful that are also included:
- [CoreOS Ignition Config Transpiler](https://github.com/coreos/container-linux-config-transpiler)
- [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)
- [FZF: command-line fuzzy finder](https://github.com/junegunn/fzf)
- [BAT: cat(1) clone with syntax highlighting and Git integration](https://github.com/sharkdp/bat)
- [EXA: ls replacement](https://github.com/ogham/exa)
- [Z: cd jump around](https://github.com/rupa/z)

## Auto-Start On Login (i.e. ~/.bashrc)
    (
      trap abort SIGINT
      abort() {
        # Return STDIN to normal mode.
        if [ -t 0 ]; then stty ${stty_settings}; fi
    
        echo -e "\n\nExiting to system shell."
        exit 1
      }
    
      # Check for interactive shell environment.
      if [[ $- = *i* ]]; then
    
        echo -e "\nPress any key to continue, or CTRL-C to abort.\n"
    
        # Put STDIN in non-blocking mode so that we can collect keypresses.
        if [ -t 0 ]; then
          stty_settings=$(stty -g)
          stty -echo -icanon -icrnl time 0 min 0
        fi
    
        # Give the user an opportunity to abort.
        for ((i=5; i>0; i--)); do
          echo -ne "\rAttaching to coreos-toolbox.service in ${i}..."
    
          # Check for a keypress.
          keypress="`cat -v`"
    
          # Continue waiting if no keypress.
          if [[ "x$keypress" = "x" ]]; then
            sleep 1
          # Continue script immediately if keypress.
          else
            if [ -t 0 ]; then stty ${stty_settings}; fi
            break
          fi
    
        done
    
        # Launch the toolbox.
        [[ ! -f ~/.zsh_history ]] && touch ~/.zsh_history
        docker exec -it coreos-toolbox.service zsh
    
        return $?
      fi
    )
    
    # Auto-exit unless there was an error attaching to the container
    if [[ "$?" = "0" ]]; then
      exit 0
    fi

