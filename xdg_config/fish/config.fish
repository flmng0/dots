
# Ensure ssh-agent is set
if not pgrep ssh-agent | string collect > /dev/null
    eval (ssh-agent -c) > /dev/null
    set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
    set -Ux SSH_AGENT_PID $SSH_AGENT_PID
end

# Modified from rebelot/kanagawa.nvim/extras/kanagawa.fish
function set_kanagawa
    # Kanagawa Fish shell theme
    # A template was taken and modified from Tokyonight:
    # https://github.com/folke/tokyonight.nvim/blob/main/extras/fish_tokyonight_night.fish
    set -l foreground DCD7BA
    set -l selection 2D4F67
    set -l comment 727169
    set -l red C34043
    set -l orange FF9E64
    set -l yellow C0A36E
    set -l green 76946A
    set -l purple 957FB8
    set -l cyan 7AA89F
    set -l pink D27E99


    # Syntax Highlighting Colors
    set -g fish_color_user $pink
    set -g fish_color_host $red

    set -g fish_color_cwd $yellow
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
end

if status is-interactive
    if not functions -q fisher
        curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
    end

    # set_tokyonight
    set_kanagawa
end

function fish_greeting
    echo The time is (set_color yellow; date +%T; set_color normal)
    echo
end

# This is a very slightly modified version of the bundled Astronaut theme
function fish_prompt --description 'Write out the prompt'
    set -l last_status $status
    set -l normal (set_color normal)
    set -l status_color (set_color brgreen)
    set -l cwd_color (set_color $fish_color_cwd)
    set -l vcs_color (set_color brpurple)
    set -l prompt_status ""

    # Since we display the prompt on a new line allow the directory names to be longer.
    set -q fish_prompt_pwd_dir_length
    or set -lx fish_prompt_pwd_dir_length 0

    # Color the prompt differently when we're root
    set -l suffix '>'
    if functions -q fish_is_root_user; and fish_is_root_user
        if set -q fish_color_cwd_root
            set cwd_color (set_color $fish_color_cwd_root)
        end
        set suffix '#'
    end

    # Color the prompt in red on error
    if test $last_status -ne 0
        set status_color (set_color $fish_color_error)
        set prompt_status $status_color "[" $last_status "]" $normal
    end

    echo -s (prompt_login) ' ' $cwd_color (prompt_pwd) $vcs_color (fish_vcs_prompt) $normal ' ' $prompt_status
    echo -n -s $status_color $suffix ' ' $normal
end

set -x XDG_CONFIG_HOME "$HOME/.config"
set -x XDG_DATA_HOME "$HOME/.local/share"
set -x XDG_CACHE_HOME "$HOME/.cache"

set -x GOPATH "$XDG_DATA_HOME/go"

fish_add_path -m ~/.local/bin
fish_add_path ~/.cargo/bin
fish_add_path /usr/local/go/bin
fish_add_path $GOPATH/bin

function remove_windows_paths
    for p in $PATH
        if not string match -q -- '/mnt/c/*' $p
            set new_path $new_path $p
        end
    end

    set -x PATH $new_path
end

