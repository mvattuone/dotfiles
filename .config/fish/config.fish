alias v "mvim -v"

# Initialize autojump 
# @See https://github.com/wting/autojump
if test -f /Users/mvattuone/.autojump/share/autojump/autojump.fish; 
  . /Users/mvattuone/.autojump/share/autojump/autojump.fish; 
end

# Start Tmux when shell starts
if status is-interactive
and not set -q TMUX
    exec tmux
end

# make Vim the default editor
set --export EDITOR "mvim -v"

# make Vim usable with git
set --export GIT_EDITOR "mvim -v"
