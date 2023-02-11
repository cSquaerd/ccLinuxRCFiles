#!/bin/bash
if [[ $1 == "-h" || $1 == "--help" ]]; then
	echo "Usage:"
	echo -e "\t./capture-card-control.sh (/dev video device) [b/brightness/c/contrast/s/saturation] [value]"
	echo "Examples:"
	echo -e "\t./capture-card-control.sh /dev/video1 b 160"
	echo -e "\t./capture-card-control.sh /dev/video5 contrast 96"
	exit
elif [[ ${#1} -lt 1 ]]; then
	echo "Error: no /dev/video device provided!"
	exit
fi

DEV=$1

if [[ ${#2} -eq 0 ]]; then
	v4l2-ctl -d $DEV --list-ctrls
	exit
elif [[ ${#2} -eq 1 ]]; then
	case $2 in
		b)
			CTRL=brightness
			;;
		c)
			CTRL=contrast
			;;
		s)
			CTRL=saturation
			;;
	esac
else
	CTRL=$2
fi

VAL=$3
RET=-1

while [[ $RET -ne 0 ]]; do
	v4l2-ctl -d $DEV -c ${CTRL}=${VAL}
	RET=$?
	if [[ $RET -ne 0 ]]; then
		echo "Command did not lock in, retrying..."
		sleep 2
		echo
	fi
done

v4l2-ctl -d $DEV --list-ctrls

