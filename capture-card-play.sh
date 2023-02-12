#!/bin/bash
if [[ $1 == "-h" || $1 == "--help" ]]; then
	echo "Usage:"
	echo -e "\t./capture-card-record.sh (/dev video device) (a/audio-only/v/video-only)"
	exit
elif [[ ${#1} -lt 1 ]]; then
	echo "Error: no /dev/video device provided!"
	exit
fi

DEV=$1

if [[ ${#2} -eq 0 ]]; then
	MODE=""
elif [[ ${#2} -eq 1 ]]; then
	case $2 in
		a)
			MODE=audio-only
			;;
		v)
			MODE=video-only
			;;
	esac
else
	MODE=$2
fi

case $MODE in
	audio-only)
		ffplay -f pulse -i default
		;;
	video-only)
		ffplay -f v4l2 -i $DEV
		;;
	*)
		ffplay -f v4l2 -i $DEV 2>/dev/null & ffplay -f pulse -i default
		;;
esac

if [[ $MODE != "audio-only" ]]; then
	echo "Now resetting UCVVideo kernel module to clear out potential bad video data..."
	# Empty out the video buffer
	sudo modprobe -vr uvcvideo
	sudo modprobe -v uvcvideo

	for I in $(seq 1 3); do
		sleep 1
		echo -n "."
	done
	echo
fi

