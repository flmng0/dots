fish_add_path /opt/nvim-linux-x86_64/bin
fish_add_path $HOME/.local/bin

function installed 
    which $argv[1] &> /dev/null
end

if installed guile || installed guile3.0 
    set -x GUILE_LOAD_PATH /usr/local/share/guile/site/3.0
    set -x GUILE_LOAD_COMPILED_PATH /usr/local/lib/guile/3.0/site-ccache
end

set -x GOPATH $HOME/.local/share/go

if test -f $HOME/.cargo/env.fish
    source $HOME/.cargo/env.fish
end

if installed nvim
    set -x EDITOR nvim
end

set BITWARDEN_SSH_SOCK  "/home/tmthy/.bitwarden-ssh-agent.sock"
if test -e $BITWARDEN_SSH_SOCK
    set -x SSH_AUTH_SOCK $BITWARDEN_SSH_SOCK
end

# mise activate fish | source
starship init fish | source

alias zypp="sudo ZYPP_PCK_PRELOAD=1 ZYPP_CURL2=1 zypper"
