# .bashrc

# User specific aliases and functions

alias rm='rm -i'
alias cp='cp -i'
alias ..='cd ../'
alias mv='mv -i'
alias netstat='netstat -tulanp'
alias c='clear'
alias ll='ls -lahf'
alias la='ls -A'
alias l='ls -CF'
alias cd..='cd ..'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias bc='bc -l'
alias mkdir='mkdir -pv'
alias diff='colordiff'
alias mount='mount |column -t'
alias h='history'
alias j='jobs -l'
alias update='yum -y update'
alias meminfo='free -m -l -t'
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'
alias pscpu='ps auxf | sort -nr -k 3'
alias pscpu10='ps auxf | sort -nr -k 3 | head -10'
alias cpuinfo='lscpu'
alias wget='wget -c'
alias df='df -H'
alias du='du -ch'
alias ls='ls --color=auto'

# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin:/root/tools/

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

export PS1="\[\e[00;36m\]\u\[\e[0m\]\[\e[00;31m\]@\[\e[0m\]\[\e[00;36m\]\h\[\e[0m\]\[\e[00;37m\]:\[\e[0m\]\[\e[00;32m\]\w\[\e[0m\]\[\e[00;37m\]\\$ \[\e[0m\]"


# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi
