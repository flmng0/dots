fish_add_path /opt/nvim-linux-x86_64/bin
fish_add_path $HOME/.local/bin

set -x GOPATH $HOME/.local/share/go

if test -f $HOME/.cargo/env.fish
    source $HOME/.cargo/env.fish
end

if which nvim 2&>1 > /dev/null
    set -x EDITOR nvim
end

set BITWARDEN_SSH_SOCK  "/home/tmthy/.bitwarden-ssh-agent.sock"
if test -f $BITWARDEN_SSH_SOCK
    set -x SSH_AUTH_SOCK $BITWARDEN_SSH_SOCK
end

mise activate fish | source
starship init fish | source
