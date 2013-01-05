# .bashrc

#---- These will auto-run every time a shell emulator is run -----------------#
# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# git tab completion
source /usr/share/doc/git-*/contrib/completion/git-completion.bash

# taken from the internets
function parse_git_branch_and_add_brackets { git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\ \[\1\]/' }

# Add terminal colors and git branch stanza
#30=black, 31=red, 32=green, 33=yellow, 34=blue, 35=magenta, 36=cyan, 37=white (your terminal emulator colors may vary)
#0=normal, 1=bold, 2=normal again, 3=background color, 4=underline, 5=blinking ex: [0;32] [1;37]
PS1="\[\e[1;37m\]\u\[\e[m\]\[\e[1;31m\]@\[\e[m\]\[\e[1;36m\]\h \[\e[1;37m\]\W\[\e[1;37m\]\$(parse_git_branch_and_add_brackets)\[\e[1;37m\]\$\[\e[m\] "

# configure ssh-agent on first run
export SSH_AUTH_SOCK=/home/$(whoami)/.ssh-socket
ssh-add -l >/dev/null 2>&1
if [ $? != 0 ]; then
   # No ssh-agent running
   rm -rf $SSH_AUTH_SOCK
   ssh-agent -a $SSH_AUTH_SOCK >/tmp/.ssh-script
   source /tmp/.ssh-script 2>/dev/null 1>/dev/null
   echo $SSH_AGENT_PID > /home/$(whoami)/.ssh-agent-pid
   rm /tmp/.ssh-script
fi

# set nvidia proprietary driver's digital vibrance
nvidia-settings -a DigitalVibrance=750 2>/dev/null 1>/dev/null
#------------------------------------------------------------------------------#


#---- Aliases for commands I use often-----------------------------------------#
# contextual grep
alias cgrep='grep -C 10 --color=auto $1 $2'

# dig +short returns only the IP if it resolves, or digs -x <IP> returns the name
alias digs='dig +short $0'

# dump the names of all resolved IPs in a given class C range
alias digr='echo "Start?"; read starting; echo "End?"; read ending; echo "Range? (xxx.xxx.xxx)"; read rangeing; for ((i="$starting"; i<="$ending"; i++)); do echo "$i" $(dig +short -x "$rangeing.$i"); done'

# Edit this file, source it when finished
alias edit='vim /home/$(whoami)/.bashrc && source /home/$(whoami)/.bashrc'

# what's using the most memory?
alias mem='ps -e -orss=,args= | sort -b -k1,1n | pr -TW$COLUMNS'

# alias for sudo /bin/su -
alias S='sudo -i'
#------------------------------------------------------------------------------#
