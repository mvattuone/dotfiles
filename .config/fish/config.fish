# Add brew to path (for apple silicon)
set PATH /opt/homebrew/bin $PATH

# Add rustup to path
set -Ua fish_user_paths $HOME/.cargo/bin

# add custom scripts to path
set -U fish_user_paths ~/bin $fish_user_paths

alias do "todoist"
alias dc "docker compose"
alias dcs "docker compose" 
alias t "docker compose -f docker-compose.yml run --rm tester python runtests.py --no-screenshot" 
alias current_version "yarn list --pattern"
alias server='python3 ~/Code/server.py'

# Start vnc server
alias vnc "cd /Users/mvattuone/code/noVNC-1.2.0 && /bin/bash utils/launch.sh --vnc localhost:5901"

# Initialize autojump 
[ -f /usr/local/share/autojump/autojump.fish ]; and source /usr/local/share/autojump/autojump.fish

# Initialize autojump
[ -f /opt/homebrew/share/autojump/autojump.fish ]; and source /opt/homebrew/share/autojump/autojump.fish


# Start Tmux when shell starts
# @NOTE (2/19/2025) - Trying out Wezterm, lets see if we still need this...
if status is-interactive
  and not set -q TMUX
  and test $TERM_PROGRAM = iTerm.app
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

# make Neovim the default editor
set --export EDITOR "nvim"

# make Neovim usable with git
set --export GIT_EDITOR "nvim"

# Use nerd fonts
set -g theme_nerd_fonts yes

# Show full directory in shell
set -U fish_prompt_pwd_dir_length 0

# Add git scripts to Path
contains $PATH $HOME/gitScripts; or set PATH $HOME/gitScripts $PATH

# Add Python to Path
contains $PATH $HOME/Library/Python/3.9/bin; or set PATH $HOME/Library/Python/3.9/bin $PATH
rvm default

setenv SSH_ENV $HOME/.ssh/environment

function start_agent                                                                                                                                                                    
    echo "Initializing new SSH agent ..."
    ssh-agent -c | sed 's/^echo/#echo/' > $SSH_ENV
    echo "succeeded"
    chmod 600 $SSH_ENV 
    . $SSH_ENV > /dev/null
    ssh-add
end

function test_identities                                                                                                                                                                
    ssh-add -l | grep "The agent has no identities" > /dev/null
    if [ $status -eq 0 ]
        ssh-add
        if [ $status -eq 2 ]
            start_agent
        end
    end
end

if [ -n "$SSH_AGENT_PID" ] 
    ps -ef | grep $SSH_AGENT_PID | grep ssh-agent > /dev/null
    if [ $status -eq 0 ]
        test_identities
    end  
else
    if [ -f $SSH_ENV ]
        . $SSH_ENV > /dev/null
    end  
    ps -ef | grep $SSH_AGENT_PID | grep -v grep | grep ssh-agent > /dev/null
    if [ $status -eq 0 ]
        test_identities
    else 
        start_agent
    end  
end
set -g fish_user_paths "/usr/local/sbin" $fish_user_paths

set -x N_PREFIX "$HOME/n"; contains "$N_PREFIX/bin" $PATH; or set -a PATH "$N_PREFIX/bin"  # Added by n-install (see http://git.io/n-install-repo).

# uv
fish_add_path "/Users/mvattuone/.local/bin"
