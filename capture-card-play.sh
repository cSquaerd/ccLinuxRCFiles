#!/bin/bash
if [[ $1 == "-h" || $1 == "--help" ]]; then
	echo "Usage:"
	echo -e "\t./capture-card-record.sh (/dev video device) (pulse input ID number) (a/audio-only/v/video-only)"
	exit
elif [[ ${#1} -lt 1 ]]; then
	echo "Error: no /dev/video device provided!"
	exit
elif [[ ${#2} -lt 1 ]]; then
	echo "Error: no PulseAudio input ID provided!"
	exit
fi

VIDDEV=$1
AUDDEV=$2

if [[ ${#3} -eq 0 ]]; then
	MODE=""
elif [[ ${#3} -eq 1 ]]; then
	case $3 in
		a)
			MODE=audio-only
			;;
		t)
			MODE=tv-aspect
			;;
		v)
			MODE=video-only
			;;
	esac
else
	MODE=$3
fi

echo "MODE IS $MODE"

case $MODE in
	audio-only)
		echo "Playing audio only"
		ffplay -f pulse -i $AUDDEV
		;;
	video-only)
		echo "Playing video only..."
		ffplay -f v4l2 -i $VIDDEV
		;;
	tv-aspect)
		echo "Playing in TV mode..."
		ffplay -f v4l2 -i $VIDDEV -vf scale=1440:1080 &
		ffplay -f pulse -i $AUDDEV 2>/dev/null
		;;
	*)
		echo "Playing video and audio..."
		ffplay -f v4l2 -i $VIDDEV &
		ffplay -f pulse -i $AUDDEV 2>/dev/null
		;;
esac

if [[ $MODE != "audio-only" ]]; then
	echo "Now resetting UCVVideo kernel module to clear out potential bad video data..."
	# Empty out the video buffer
	sudo modprobe -vr uvcvideo

	for I in $(seq 1 3); do
		sleep 1
		echo -n "."
	done
	echo

	sudo modprobe -v uvcvideo

	for I in $(seq 1 3); do
		sleep 1
		echo -n "."
	done
	echo
fi

