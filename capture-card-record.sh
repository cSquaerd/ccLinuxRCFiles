#!/bin/bash
if [[ $1 == "-h" || $1 == "--help" ]]; then
	echo "Usage:"
	echo -e "\t./capture-card-record.sh (/dev video device) (output directory) [preferred bitrate] [preferred bufsize]"
	exit
elif [[ ${#1} -lt 1 ]]; then
	echo "Error: no /dev/video device provided!"
	exit
elif [[ ${#2} -lt 1 ]]; then
	echo "Error: no output directory provided!"
	exit
fi

BITRATE=16
BUFSIZE=8
# Keep BUFSIZE approximately equal to half of BITRATE

if [[ ${#3} -gt 0 ]]; then
	BITRATE=$3
fi
if [[ ${#4} -gt 0 ]]; then
	BUFSIZE=$4
fi

ffmpeg \
	-f v4l2 -i $1 \
	-f pulse -i default \
	-b:v ${BITRATE}M -maxrate ${BITRATE}M -bufsize ${BUFSIZE}M \
	-preset veryfast -c:v libx264 -c:a libvorbis \
	-f matroska $2/recording-$(date "+%m_%d_%y-%I_%M_%S-%p").mkv

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

