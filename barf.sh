#!/bin/bash
BLOCK_TH="\u2580"
BLOCK_BH="\u2584"
BLOCK_LH="\u258C"
BLOCK_RH="\u2590"
BLOCK_QBL="\u2596"
BLOCK_QBR="\u2597"
BLOCK_QTL="\u2598"
BLOCK_QTR="\u259D"
BLOCK_CBL="\u2599"
BLOCK_CBR="\u259F"
BLOCK_CTL="\u259B"
BLOCK_CTR="\u259C"
BLOCK_BS="\u259A"
BLOCK_FS="\u259E"
BLOCK_A="\u2588"
BLOCK_O=" "

BLOCKS=(
	${BLOCK_TH} ${BLOCK_BH} ${BLOCK_LH} ${BLOCK_RH}
	${BLOCK_QBL} ${BLOCK_QBR} ${BLOCK_QTL} ${BLOCK_QTR}
	${BLOCK_CBL} ${BLOCK_CBR} ${BLOCK_CTL} ${BLOCK_CTR}
	${BLOCK_BS} ${BLOCK_FS} ${BLOCK_A} ${BLOCK_O}
)
FG=$(seq 30 37; seq 90 97)
BG=$(seq 40 47; seq 100 107)
COLOR_STRINGS=("red" "green" "yellow" "blue" "magenta" "cyan" "white")

ANSI_ESCAPE="\033["

MONO=0
for ARG in ${@}; do
	if [[ ${ARG} == "-h" || ${ARG} == "--half" ]]; then
		BLOCKS=( ${BLOCK_TH} ${BLOCK_BH} ${BLOCK_A} ${BLOCK_O} )
		echo "Only vertical half blocks and whole blocks active."
	elif [[ ${ARG} == "-m" || ${ARG} == "--mono" || ${ARG} == "--monocolor" ]]; then
		echo "Looking for monocolor color."
		MONO=1
	elif (( MONO )) && [[ ${COLOR_STRINGS[*]} =~ ${ARG} ]]; then
		echo "Monocolor mode active with ${ARG}."
		MONO=0

		case ${ARG} in
			"red")
				FG="30 91"
				BG="40 101"				
				;;
			"green")
				FG="30 92"
				BG="40 102"				
				;;
			"yellow")
				FG="30 93"
				BG="40 103"				
				;;
			"blue")
				FG="30 94"
				BG="40 104"				
				;;
			"magenta")
				FG="30 95"
				BG="40 105"				
				;;
			"cyan")
				FG="30 96"
				BG="40 106"				
				;;
			"white")
				FG="30 97"
				BG="40 107"				
				;;
		esac
	fi
done

get_block() {
	echo ${BLOCKS[*]} | sed 's/ /\n/g' | shuf -n 1
}

get_foreground_color() {
	echo ${FG} | sed 's/ /\n/g' | shuf -n 1
}

get_background_color() {
	echo ${BG} | sed 's/ /\n/g' | shuf -n 1
}

get_row() {
	seq 1 $(tput lines) | shuf -n 1
}

get_column() {
	seq 1 $(tput cols) | shuf -n 1
}

echo "Press return to stop."

# Hide the cursor
echo -en "${ANSI_ESCAPE}?25l"

while : ; do
	echo -en "${ANSI_ESCAPE}$(get_row);$(get_column)H"
	echo -en "${ANSI_ESCAPE}$(get_foreground_color);$(get_background_color)m$(get_block)${ANSI_ESCAPE}0m"
	read -t 0
	if (( ! $? )); then
		break 
	fi
done

# Show the cursor
echo -en "${ANSI_ESCAPE}?25h"

