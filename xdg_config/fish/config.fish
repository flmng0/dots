if status is-interactive
    # Commands to run in interactive sessions can go here
    if not functions -q fisher
        curl -sL https://git.io/fisher | source
        fisher install jorgebucaran/fisher
    end

    if not functions -q set_onedark
        fisher install rkbk60/onedark-fish
    end

    set -l onedark_options '-b'
    if set -q VIM
        set onedark_options '-256'
    end

    set_onedark $onedark_options
end

fish_add_path -m ~/.local/bin
fish_add_path ~/.cargo/bin
