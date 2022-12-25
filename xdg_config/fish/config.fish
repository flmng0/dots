
function set_tokyonight
    # from: https://raw.githubusercontent.com/folke/tokyonight.nvim/main/extras/fish/tokyonight_moon.fish

    # TokyoNight Color Palette
    set -l foreground c8d3f5
    set -l selection 3654a7
    set -l comment 7a88cf
    set -l red ff757f
    set -l orange ff966c
    set -l yellow ffc777
    set -l green c3e88d
    set -l purple fca7ea
    set -l cyan 86e1fc
    set -l pink c099ff

    # Syntax Highlighting Colors
    set -g fish_color_normal $foreground
    set -g fish_color_command $cyan
    set -g fish_color_keyword $pink
    set -g fish_color_quote $yellow
    set -g fish_color_redirection $foreground
    set -g fish_color_end $orange
    set -g fish_color_error $red
    set -g fish_color_param $purple
    set -g fish_color_comment $comment
    set -g fish_color_selection --background=$selection
    set -g fish_color_search_match --background=$selection
    set -g fish_color_operator $green
    set -g fish_color_escape $pink
    set -g fish_color_autosuggestion $comment

    # Completion Pager Colors
    set -g fish_pager_color_progress $comment
    set -g fish_pager_color_prefix $cyan
    set -g fish_pager_color_completion $foreground
    set -g fish_pager_color_description $comment
    set -g fish_pager_color_selected_background --background=$selection
end

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

    set_tokyonight
end

function fish_greeting
    echo The time is (set_color yellow; date +%T; set_color normal)
    echo
end

set -x XDG_CONFIG_HOME "$HOME/.config"

fish_add_path -m ~/.local/bin
fish_add_path ~/.cargo/bin
fish_add_path /usr/local/go/bin

function remove_windows_paths
    for p in $PATH
        if not string match -q -- '/mnt/c/*' $p
            set new_path $new_path $p
        end
    end

    set -x PATH $new_path
end

