ENV=$HOME/dotfiles/.bashrc
export ENV

PATH=/usr/local/bin:$PATH:$HOME/bin

ssh_agent="$HOME/.ssh-agent.sh"
if [ -f $ssh_agent ]
then
  source $ssh_agent > /dev/null
fi

# General aliases
alias ..='cd ..'
alias l.='ls -G -d .*'
alias ll='ls -G -l'
alias ls='ls -G'
alias vi='vim'
alias which='alias | /usr/bin/which'
alias rfind='find -L . -iname '
alias rgrep='grep -ri --exclude="tags" --exclude="*pyc" --color=auto '

# DB
alias startmysql='mysql.server start'
alias stopmysql='mysql.server stop'
alias startpostgres='pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start'
alias stoppostgres='pg_ctl -D /usr/local/var/postgres stop -s -m fast'

# Python
PYTHONPATH=/Library/Python/2.7/site-packages:$PYTHONPATH

# Ruby / Rails
PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
alias migrate='rake db:migrate && rake db:test:prepare'

# Node
NODEPATH=/usr/local/lib/node_modules

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

HISTFILESIZE=2500
HISTSIZE=2500
LOG_LEVEL='info'

# Now comes some awesomeness to setup my bash prompt for source control
source /usr/local/etc/bash_completion.d/git-completion.bash

# This code was autogenerated with these options:
# http://andrewray.me/bash-prompt-builder/index.html#git=1&color-git=3&git-prefix=1&color-git-prefix=3&git-ahead=1&color-git-ahead=6b&git-modified=1&color-git-modified=3&color-git-conflicted=1&color-git-revno=3&color-git-bisect=5&color-option-submodule=5&color-git-ontag=3&color-hg=5&color-hg-prefix=5&color-hg-modified=5&color-hg-conflicted=1&color-hg-revno=5&color-hg-bisect=3&color-hg-patches=3&color-svn=6&color-svn-modified=6&color-svn-revno=6&option-modified=%E2%96%B3&option-conflict=%E2%98%A2&color-option-conflict=3&max-conflicted-files=2&option-nobranch=no%20branch&color-option-nobranch=1&bisecting-text=bisecting&submodule-text=%5Bsubmodule%5D%20

MAX_CONFLICTED_FILES=2
DELTA_CHAR="△"
CONFLICT_CHAR="☢"
BISECTING_TEXT="bisecting"
NOBRANCH_TEXT="no branch"
SUBMODULE_TEXT=""

# Colors for prompt
COLOR_RED=$(tput sgr0 && tput setaf 1)
COLOR_GREEN=$(tput sgr0 && tput setaf 2)
COLOR_YELLOW=$(tput sgr0 && tput setaf 3)
COLOR_BLUE=$(tput sgr0 && tput setaf 4)
COLOR_MAGENTA=$(tput sgr0 && tput setaf 5)
COLOR_CYAN=$(tput sgr0 && tput setaf 6)
COLOR_GRAY=$(tput sgr0 && tput setaf 7)
COLOR_WHITE=$(tput sgr0 && tput setaf 7 && tput bold)
COLOR_LIGHTRED=$(tput sgr0 && tput setaf 1 && tput bold)
COLOR_LIGHTGREEN=$(tput sgr0 && tput setaf 2 && tput bold)
COLOR_LIGHTYELLOW=$(tput sgr0 && tput setaf 3 && tput bold)
COLOR_LIGHTBLUE=$(tput sgr0 && tput setaf 4 && tput bold)
COLOR_LIGHTMAGENTA=$(tput sgr0 && tput setaf 5 && tput bold)
COLOR_LIGHTCYAN=$(tput sgr0 && tput setaf 6 && tput bold)

COLOR_RESET=$(tput sgr0)



_git_dir=""
function _git_check {
    _git_dir=`git rev-parse --show-toplevel 2> /dev/null`
    if [[ "$_git_dir" == "" ]]; then
        return 1
    else
        return 0
    fi
}

function is_submodule() {
    local parent_git=`cd "$_git_dir/.." && git rev-parse --show-toplevel 2> /dev/null`
    if [[ -n $parent_git ]]; then
        local submodules=`cd $parent_git && git submodule --quiet foreach 'echo $path'`
        for line in $submodules; do
            cd "$parent_git/$line"
            if [[ `pwd` = $_git_dir ]]; then return 0; fi
        done
    fi
    return 1
}

dvcs_function="
    # Figure out what repo we are in
    _git_check

    # Build the prompt!
    prompt=\"\"

    # If we are in git ...
    if [ -n \"\$_git_dir\" ]; then
        # find current branch
        gitBranch=\$(git symbolic-ref HEAD 2> /dev/null)
        gitStatus=\`git status\`

        # Figure out current branch, or if we are bisecting, or lost in space
        bisecting=\"\"
        noBranch=\"\"
        if [ -z \"\$gitBranch\" ]; then
            noBranch=True
            gitBranch=\"\\[\$COLOR_RED\\]\$NOBRANCH_TEXT\\[\$COLOR_YELLOW\\]\"
        fi

        # changed *tracked* files in local directory?
        gitChange=\$(echo \$gitStatus | ack 'modified:|deleted:|new file:')
        if [ -n \"\$gitChange\" ]; then
            gitChange=\"\\[\$COLOR_YELLOW\\] \\[`tput sc`\\]  \\[`tput rc`\\]\\[\$DELTA_CHAR\\] \"
        fi

        # output the branch and changed character if present
        prompt=\$prompt\"\\[\$COLOR_YELLOW\\] (\"

        if is_submodule; then
            prompt=\$prompt\"\\[\$COLOR_MAGENTA\\]\$SUBMODULE_TEXT\\[\$COLOR_YELLOW\\]\"
        fi

        prefix=\"\\[\$COLOR_YELLOW\\]git:\\[\$COLOR_YELLOW\\]\"
        prompt=\$prompt\$prefix\${gitBranch#refs/heads/}\$bisecting
        prompt=\$prompt\"\$gitChange\\[\$COLOR_YELLOW\\])\\[\$COLOR_RESET\\]\"

        # How many local commits do you have ahead of origin?
        num=\$(echo \$gitStatus | grep \"Your branch is ahead of\" | awk '{split(\$0,a,\" \"); print a[13];}') || return
        if [ -n \"\$num\" ]; then
            prompt=\$prompt\"\\[\$COLOR_LIGHTCYAN\\] +\$num\"
        fi

    fi



    # Show conflicted files if any
    if [ -n \"\$files\" ]; then
        prompt=\$prompt\" \\[\$COLOR_RED\\](\\[\$COLOR_YELLOW\\]\"
        prompt=\$prompt\"\\[`tput sc`\\]  \\[`tput rc`\\]\\[\$COLOR_YELLOW\\]\\[\$CONFLICT_CHAR\\] \"
        prompt=\$prompt\"\\[\$COLOR_RED\\] \${files})\"
    fi

    echo -e \$prompt"
# End code auto generated by http://andrewray.me/bash-prompt-builder/index.html

PS1="\u:\W\$(${dvcs_function})\[$COLOR_RESET\] \$ "

# Setup specific to individual clients
source ~/dotfiles/.bash_work_setup
