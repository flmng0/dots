if status is-interactive
    # Commands to run in interactive sessions can go here
end

fish_add_path /opt/nvim-linux-x86_64/bin
fish_add_path $HOME/.bun/bin
fish_add_path $HOME/.local/bin
source $HOME/.cargo/env.fish

set -x FLYCTL_INSTALL "/home/tmthy/.fly"
fish_add_path "$FLYCTL_INSTALL/bin"

mise activate fish | source
starship init fish | source
