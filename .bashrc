# .bashrc

# User specific aliases and functions

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias netstat='netstat -tulanp'
alias c='clear'
alias ll='ls -lah'
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
alias top='atop'


# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi
