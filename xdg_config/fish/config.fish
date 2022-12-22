if status is-interactive
    infocmp alacritty >/dev/null 2>/dev/null
    if test $status -eq 0
        set -x TERM "alacritty"
    end

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

function fish_greeting
    echo The time is (set_color yellow; date +%T; set_color normal)
    echo
end

fish_add_path -m ~/.local/bin
fish_add_path ~/.cargo/bin
fish_add_path /usr/local/go/bin
