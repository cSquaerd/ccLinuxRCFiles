# Allows for editing the prompt (??)
autoload -Uz compinit promptinit
compinit
promptinit
# Prompts left and right! Ah!
PROMPT="%B%n%b@%F{12}%S%M%s%f:%U%3~%u $ "
RPROMPT="[%?] %*, %W"
# Case-agnostic completions
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
# ls aliases
alias ls="ls -XshFH --color=auto"
alias lsa="ls -a"
alias ll="ls -l"
alias lla="ll -a"
alias lz="ls -S"
alias lza="lz -a"
# coreutil & systemd aliases
alias susys="sudo systemctl"
alias df="df -hT -x \"tmpfs\" -x \"devtmpfs\""
alias du="du -chs "
alias grep="grep --color=auto -i"
alias grepn="grep -n"
alias path="env | grep PATH="
alias lsblk="lsblk -o NAME,TYPE,FSTYPE,SIZE,FSUSED,FSUSE%,MOUNTPOINT"
alias watch="watch -td -cpn 1 "
alias shufone="shuf -en 1"
# pacman & yay aliases
alias pacins="sudo pacman -Sy"
alias pacsch="pacman -Ss"
alias pacrmv="sudo pacman -Rns"
alias paccln="sudo pacman -Sc"
alias aurins="yay -Sy"
alias aursch="yay -Ssa"
alias aurcln="yay -Sc"
alias pacsiz="pacgraph -c | grep -v \"warning:\" | grep \"MB\""
alias grin="grep installed -A 1"
# rebootCheck components
kernelName="linux-zen"
kernelSuffix="zen"
alias getKernelVersions="installedKernel=\$(pacman -Q $kernelName | awk '{print \$2}' | awk -F '.$kernelSuffix' '{print \$1}'); runningKernel=\$(uname -r | awk -F '-' '{print \$1}')"
alias rebootCheck="getKernelVersions; echo '  Running Kernel Version:' \$runningKernel; echo 'Installed Kernel Version:' \$installedKernel; if [ \"\$runningKernel\" \=\= \"\$installedKernel\" ]; then; echo 'No reboot required.'; else; echo 'New kernel installed! Please reboot!'; fi"
# update one-liner script & alias
alias upd="yay -Syu; yay -Sc; pacrmv \$(pacman -Qtdq); echo; rebootCheck; echo; echo 'Update complete.'; echo"
alias update="upd"
# text editor aliases
alias vm="vim"
alias sdvm="sudo vim"
# cool programs aliases
alias nload="nload -u H -t 250"
alias cmatrix="cmatrix -bu 2"
alias banner="banner -f 2 -c # "
alias polltemps="sensors | tail | grep \"Tctl\|edge\" | awk '/Tctl/ {printf \"CPU: %4.1f\n\", \$2} /edge/ {printf \"GFX: %4.1f\n\", \$2}'"
# tmux aliases
alias tmuxs="tmux new -s tmux"
alias tmuxr="tmux attach"
alias tmuxl="tmux list-sessions"
alias tmuxk="tmux kill-session"
# fun stuff aliases
alias termsize="echo \$LINES lines x \$COLUMNS columns"
alias cowsay="cowsay -W 72"
alias fortune="fortune -sn 384 computers debian education linux literature magic news perl science startrek wisdom"
# cowfile fetchers
alias getspam="shufone \$(\\ls ~/cowfiles/spam*)"
alias gethero="shufone \$(\\ls ~/cowfiles/*ff*)"
alias getsprite="shufone \$(\\ls ~/cowfiles/*)"
# delayed printing
alias printstag="awk '{print \$0; system(\"sleep 0.035\");}'"
alias printslow="awk '{print \$0; system(\"sleep 0.100\");}'"
# very fun stuff aliases
alias spritefortune="fortune | cowsay -f \$(getsprite) | printstag"
alias herofortune="fortune | cowsay -f \$(gethero) | printstag"
alias spamfortune="fortune | cowsay -f \$(getspam) | printstag"
# Get the navigation keys to actually work like in bash
typeset -g -A key
# Map the keycodes from terminfo to something usable
key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Delete]="${terminfo[kdch1]}"
key[CtrlRight]="${terminfo[kRIT5]}"
key[CtrlLeft]="${terminfo[kLFT5]}"
# Connect the mapped codes with functions
[[ -n "${key[Home]}" ]] && bindkey -- "${key[Home]}" beginning-of-line
[[ -n "${key[End]}" ]] && bindkey -- "${key[End]}" end-of-line
[[ -n "${key[Delete]}" ]] && bindkey -- "${key[Delete]}" delete-char
[[ -n "${key[CtrlRight]}" ]] && bindkey -- "${key[CtrlRight]}" forward-word
[[ -n "${key[CtrlLeft]}" ]] && bindkey -- "${key[CtrlLeft]}" backward-word
# Allow all functions to be handled by ZLE
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
	autoload -Uz add-zle-hook-widget
	function zle_app_mode_start { echoti smkx }
	function zle_app_mode_stop { echoti rmkx }

	add-zle-hook-widget -Uz zle-line-init zle_app_mode_start
	add-zle-hook-widget -Uz zle-line-finish zle_app_mode_stop
fi
# Console font init
if [[ "${TERM}" == "linux" ]] then
	TERM=linux-16color
	setfont latarcyrheb-sun32;
fi
# Shell startup
ufetch | printstag; spritefortune | printstag

