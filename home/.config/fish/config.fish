if status is-interactive
    # Commands to run in interactive sessions can go here
end

fish_add_path $HOME/.local/bin

mise activate fish | source
starship init fish | source
