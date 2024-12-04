if status is-interactive
    # Commands to run in interactive sessions can go here
end

fish_add_path $HOME/.deno/bin
fish_add_path $HOME/.bun/bin
fish_add_path $HOME/.local/bin
source $HOME/.cargo/env.fish

mise activate fish | source
starship init fish | source
