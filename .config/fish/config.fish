alias v "mvim -v"

# Initialize autojump 
[ -f /usr/local/share/autojump/autojump.fish ]; and source /usr/local/share/autojump/autojump.fish

# Start Tmux when shell starts
if status is-interactive
and not set -q TMUX
    exec tmux -2
end

# Vim mode
function fish_user_key_bindings
  fish_vi_key_bindings

   bind -M insert -m default jk backward-char force-repaint
end

# make Vim the default editor
set --export EDITOR "mvim -v"

# make Vim usable with git
set --export GIT_EDITOR "mvim -v"

# Use nerd fonts
set -g theme_nerd_fonts yes

# Show full directory in shell
set -U fish_prompt_pwd_dir_length 0

# Add Python to Path
set PATH /Users/mikevattuone/Library/Python/3.7/bin $PATH
