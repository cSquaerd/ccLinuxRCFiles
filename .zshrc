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
alias top="top -d 1 -e m -E g -u charlie"
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
function rebootCheck() {
	getKernelVersions
	echo '  Running Kernel Version:' $runningKernel
	echo 'Installed Kernel Version:' $installedKernel;
	if [[ "$runningKernel" == "$installedKernel" ]]; then
		echo 'No reboot required.'
	else
		echo 'New kernel installed! Please reboot!'
	fi
}
# update one-liner script & alias
alias upd="yay -Syu; yay -Sc; pacrmv \$(pacman -Qtdq); echo; rebootCheck; echo; echo 'Update complete.'; echo"
alias update="upd"
# text editor aliases
alias vm="vim"
alias sdvm="sudo vim"
# ssh-agent aliases
alias sysusr="systemctl --user"
alias sshkls="ssh-add -l"
alias sshkul="ssh-add .ssh/daedalusKey"
alias sshklk="ssh-add -D"
# Alacritty settings aliases
alias alaftszg="grep size ~/.alacritty.yml | cut -d ':' -f 2 | xargs"
function ala_font_size_set {
	MINSIZE=8
	if (( ${#2} == 0 )); then
		OLDSIZE=$(alaftszg)
	else
		OLDSIZE=$2
	fi
	NEWSIZE=$1

	if (( $NEWSIZE >= $MINSIZE )); then
		sed -i.old "s/size: $OLDSIZE/size: $NEWSIZE/" ~/.alacritty.yml
	fi
}
function ala_font_size_tick {
	DELTA=$1
	OLDSIZE=$(alaftszg)
	(( NEWSIZE = $OLDSIZE + $DELTA ))

	ala_font_size_set $NEWSIZE $OLDSIZE
}
alias alaftszs="ala_font_size_set"
alias alaftszp="ala_font_size_tick 1"
alias alaftszm="ala_font_size_tick -1"
alias alaalphg="grep opacity ~/.alacritty.yml | cut -d ':' -f 2 | xargs"
function ala_alpha_tick {
	DELTA=$1
	OLDALPHA=$(alaalphg)
	(( NEWALPHA = $OLDALPHA + $DELTA ))

	if (( $NEWALPHA >= 0.0 && $NEWALPHA <= 1.0 )); then
		sed -i.old "s/opacity: $OLDALPHA/opacity: $NEWALPHA/" ~/.alacritty.yml
	fi
}
alias alaalphp="ala_alpha_tick 0.05"
alias alaalphm="ala_alpha_tick -0.05"
# cool programs aliases
alias nload="nload -u H -t 250"
alias cmatrix="cmatrix -bu 2"
alias banner="banner -f 2 -c # "
alias polltemps="sensors | tail | grep \"Tctl\|edge\" | awk '/Tctl/ {printf \"CPU: %4.1f\n\", \$2} /edge/ {printf \"GFX: %4.1f\n\", \$2}'"
# note: on most of my systems, the cpu line produced by polltemps is below the gfx line; if the opposite is true on your system, swap the comma and newline in the below alias, as well as swapping the order of the echo subcommand and the color argument in the termgraph alias
alias filtertemps="echo \"@ GFX,CPU\"; awk '/GFX/ {printf \$2\",\"}; /CPU/ {printf \$2\"\n\"}; /\// {printf \$2\",\"}'"
alias mydate="date \"+%_m/%d/%g, %_I:%M:%S %p\""
alias logtemp="(mydate; polltemps; echo ---)"
tmprFile="~/.temperature.dat"
function tempgraph() {
	READINGS=1;
	if [[ "$1" != "" ]]; then
		TERMGRAPHSLEEP=$1
	else
		TERMGRAPHSLEEP=1
	fi
	while : ; do
		eval "logtemp >> $tmprFile"
		eval "(filtertemps $tmprFile | tail -n $READINGS) | termgraph --color {blue,black} --suffix \" °C\""
		READINGS=$(echo "if ( (2*$READINGS+1)+6 < $LINES ) $READINGS+1 else ($LINES - 6) / 2" | bc)
		sleep $TERMGRAPHSLEEP
	done
}
alias getrand="hexdump -dn 1 /dev/random | head -n 1 | awk '{print \$2}' | cut -c 3-5"
function rolldice() {
	echo "Rolling $2d$1..."
	SUM=0
	for i in $(seq 1 $2); do
		ROLL=$(echo "(" $(getrand) "% $1) + 1" | bc)
		printf "Got a % 6d!\n" $ROLL
		SUM=$(echo "$SUM + $ROLL" | bc)
	done
	printf "Total: % 5d\n" $SUM
}
loadbar_delay=0.1225
function loadbar() {
	LIMIT=$(echo "$1 * 8" | bc 2>/dev/null)
	if (( $? == 2 )); then
		LIMIT=40
	fi
	for I in $(seq 1 $LIMIT); do
		if (( $I % 80 == 0 )); then
			echo -e '\x1B[0;5;7m!\x1B[0m'
		elif (( $I % 8 == 0 )) then
			echo -en '\x1B[0;5;7m!\x1B[0m'
		elif (( $I % 4 == 0 )); then
			echo -n ':'
		else
			echo -n '.'
		fi
		sleep $loadbar_delay
	done
	echo
}
TIMEFMT="%*E"
function loadbar-delta() {
	echo "NOW RUNNING 10 SECOND LOADBAR..."
	TENSEC=$({ time ( loadbar 10 1>/dev/null ); } 2>&1)
	echo "ELAPSED TIME: $TENSEC"
	echo "CURRENT DELAY: $loadbar_delay"
	echo -n "DELTA: "; echo "0.125 - ($TENSEC / 80)" | bc -l
}
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
alias gethero="shufone \$(\\ls ~/cowfiles/*_ff*)"
alias getsprite="shufone \$(\\ls ~/cowfiles/*)"
# delayed printing
alias printstag="awk '{print \$0; system(\"sleep 0.035\");}'"
alias printslow="awk '{print \$0; system(\"sleep 0.100\");}'"
# very fun stuff aliases
alias spritefortune="fortune | cowsay -f \$(getsprite)"
alias herofortune="fortune | cowsay -f \$(gethero)"
alias spamfortune="fortune | cowsay -f \$(getspam)"
function show-cowfiles() {
	X=""
	PATHTOCOWSPRITES=/home/charlie/Desktop/ccCowsprites
	while : ; do
		python ${PATHTOCOWSPRITES}/paletteTest.py | printstag
		sleep 0.5
		for c in ~/cowfiles/*; do
			cowsay -f $c $(basename -s ".cow" $c) | printstag
			read -k 1 -t 0.5 X
			if [[ ${#X} -gt 0 ]]; then
				break
			fi
		done
	if [[ ${#X} -gt 0 ]]; then
		break
	fi
	done
}
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
( pfetch; spritefortune ) | printstag

