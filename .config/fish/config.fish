alias v "mvim -v"
alias dc "docker-compose"
alias dcs "docker-compose -f docker-compose.yml -f docker-compose.selenium.yml"
alias t "docker-compose -f docker-compose.yml -f docker-compose.selenium.yml run tester python runtests.py --no-screenshot" 

# Initialize autojump 
[ -f /usr/local/share/autojump/autojump.fish ]; and source /usr/local/share/autojump/autojump.fish

# Start Tmux when shell starts
if status is-interactive
and not set -q TMUX
    exec tmux -2
end

# Initialize pyenv
status --is-interactive; and source (pyenv init -|psub)

# Vim mode
function fish_user_key_bindings
  fish_vi_key_bindings

   bind -M insert -m default jk backward-char force-repaint
end

contains $fish_user_paths $HOME/n/bin; or set -U fish_user_paths $HOME/n/bin $fish_user_paths

# make Vim the default editor
set --export EDITOR "mvim -v"

# make Vim usable with git
set --export GIT_EDITOR "mvim -v"

# Use nerd fonts
set -g theme_nerd_fonts yes

# Show full directory in shell
set -U fish_prompt_pwd_dir_length 0

# Add git scripts to Path
contains $PATH $HOME/gitScripts; or set PATH $HOME/gitScripts $PATH

# Add Python to Path
contains $PATH $HOME/Library/Python/3.7/bin; or set PATH $HOME/Library/Python/3.7/bin $PATH
rvm default

test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish

