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
	${BLOCK_BS} ${BLOCK_FS} ${BLOCK_A} "${BLOCK_O}"
)
# Index formula = 3 * (dR + 1) + (dC + 1) for -1 <= dR, dC <= 1;
# Hence, from 0 to 8, we have (-1, -1), (-1, 0), (-1, 1) ...
# to (1, -1), (1, 0), (1, 1).
# Remember that lower rows are near the top of the terminal.
DIRECTIONAL_BLOCKS=(
	${BLOCK_BS} ${BLOCK_RH} ${BLOCK_FS}
	${BLOCK_TH} ${BLOCK_QBR} ${BLOCK_BH}
	${BLOCK_FS} ${BLOCK_LH} ${BLOCK_BS}

)
echo "${#BLOCKS[*]} ${#DIRECTIONAL_BLOCKS[*]}"
FG=$(seq 30 37; seq 90 97)
BG=$(seq 40 47; seq 100 107)
COLOR_STRINGS=("red" "green" "yellow" "blue" "magenta" "cyan" "white")

ANSI_ESCAPE="\033["

MONO=0
DIRECTIONAL=0
SNAKE=0
LOG=0
LOGFILE="/tmp/barf.log"

delta_row=0
delta_column=0

get_delta() {
	echo seq -1 1 | sed 's/ /\n/g' | shuf -n 1
}

get_row() {
	(( SNAKE )) && R=$(tput lines) &&
	echo "r1 = (${R0} + $(get_delta)) % (${R} + 1); if (r1 == 0) if (${R0} == 1) ${R} else 1 else r1" | bc ||
	seq 1 $(tput lines) | shuf -n 1
}

get_column() {
	(( SNAKE )) && C=$(tput cols) &&
	echo "c1 = (${C0} + $(get_delta)) % (${C} + 1); if (c1 == 0) if (${C0} == 1) ${C} else 1 else c1" | bc ||
	seq 1 $(tput cols) | shuf -n 1
}

for ARG in ${@}; do
	if [[ ${ARG} == "-h" || ${ARG} == "--half" ]]; then
		BLOCKS=( ${BLOCK_TH} ${BLOCK_BH} ${BLOCK_A} ${BLOCK_O} )
		echo "Only vertical half blocks and whole blocks active."
	elif [[ ${ARG} == "-s" || ${ARG} == "--snake" ]]; then
		R0=$(get_row)
		C0=$(get_column)

		SNAKE=1
		echo "Snake mode active, starting from (${C0}, ${R0})."
	elif [[ ${ARG} == "-l" || ${ARG} == "--log" ]]; then
		LOG=1

		echo "" > ${LOGFILE}
		echo "Logging enabled."
	elif [[ ${ARG} == "-m" || ${ARG} == "--mono" || ${ARG} == "--monocolor" ]]; then
		echo "Looking for monocolor color."
		MONO=1
	elif [[ ${ARG} == "-d" || ${ARG} == "--directional" ]]; then
		echo "Directional block character mode active."
		DIRECTIONAL=1
	elif (( MONO )) && [[ ${COLOR_STRINGS[*]} =~ ${ARG} ]]; then
		echo "Monocolor mode active with ${ARG}."
		MONO=0

		case ${ARG} in
			"red")
				FG="91"
				BG="40"
				;;
			"green")
				FG="92"
				BG="40"
				;;
			"yellow")
				FG="93"
				BG="40"
				;;
			"blue")
				FG="94"
				BG="40"
				;;
			"magenta")
				FG="95"
				BG="40"
				;;
			"cyan")
				FG="96"
				BG="40"
				;;
			"white")
				FG="97"
				BG="40"
				;;
		esac
	fi
done

get_block() {
	(( DIRECTIONAL && SNAKE )) && R1=${1} && R0=${2} && C1=${3} && C0=${4} &&
	DR=$(echo "dr = ${R1} - ${R0}; if (dr < -1) -1 else if (dr > 1) 1 else dr" | bc) &&
	DC=$(echo "dc = ${C1} - ${C0}; if (dc < -1) -1 else if (dc > 1) 1 else dc" | bc) &&
	(( I_CHAR = 3 * (DR + 1) + (DC + 1) )) &&
	echo ${DIRECTIONAL_BLOCKS[${I_CHAR}]} ||
	echo ${BLOCKS[*]} | sed 's/ /\n/g' | shuf -n 1
	
	#(( LOG )) &&
	#echo -e "\t(${DC}, ${DR})" >> ${LOGFILE} &&
	#echo -e "\t${I_CHAR}" >> ${LOGFILE}
}

get_foreground_color() {
	echo ${FG} | sed 's/ /\n/g' | shuf -n 1
}

get_background_color() {
	echo ${BG} | sed 's/ /\n/g' | shuf -n 1
}

echo "Press return to stop."

# Hide the cursor
echo -en "${ANSI_ESCAPE}?25l"

while : ; do
	R1=$(get_row)
	C1=$(get_column)
	echo -en "${ANSI_ESCAPE}${R1};${C1}H"
	echo -en "${ANSI_ESCAPE}$(get_foreground_color);$(get_background_color)m$(get_block ${R1} ${R0} ${C1} ${C0})${ANSI_ESCAPE}0m"

	(( LOG )) && echo "("$(echo "${C1} - ${C0}" | bc)", "$(echo "${R1} - ${R0}" | bc)"): (${C0}, ${R0}) -> (${C1}, ${R1})" >> ${LOGFILE}

	R0=$R1
	C0=$C1

	read -t 0
	if (( ! $? )); then
		break 
	fi
done

# Show the cursor
echo -en "${ANSI_ESCAPE}?25h"

