alias do "todoist"
alias v "mvim -v -w ~/code/dotfiles/vim/keystrokes.log"
alias dc "docker-compose"
alias dcs "docker-compose -f docker-compose.yml -f docker-compose.selenium.yml"
alias t "docker-compose -f docker-compose.yml -f docker-compose.selenium.yml run tester python runtests.py --no-screenshot" 

# Start vnc server
alias vnc "~/code/noVNC-1.2.0/utils/launch.sh"

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
