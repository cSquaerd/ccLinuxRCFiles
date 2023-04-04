#!/bin/bash
if [[ $1 == "-h" || $1 == "--help" ]]; then
	echo "Usage:"
	echo -e "\t./capture-card-record.sh (/dev video device) (pulse input ID number) (output directory) [preferred bitrate] [preferred bufsize] [tv aspect ratio]"
	exit
elif [[ ${#1} -lt 1 ]]; then
	echo "Error: no /dev/video device provided!"
	exit
elif [[ ${#2} -lt 1 ]]; then
	echo "Error: no PulseAudio input ID provided!"
	exit
elif [[ ${#3} -lt 1 ]]; then
	echo "Error: no output directory provided!"
	exit
fi

BITRATE=16
BUFSIZE=8
# Keep BUFSIZE approximately equal to half of BITRATE

if [[ ${#4} -gt 0 ]]; then
	BITRATE=$4
fi
if [[ ${#5} -gt 0 ]]; then
	BUFSIZE=$5
fi

if [[ $6 == "tv" ]]; then
	ffmpeg \
		-f v4l2 -i $1 \
		-f pulse -i $2 \
		-b:v ${BITRATE}M -maxrate ${BITRATE}M -bufsize ${BUFSIZE}M \
		-preset veryfast -c:v libx264 -c:a libvorbis \
		-vf scale=1440:1080 \
		-f matroska $3/recording-$(date "+%m_%d_%y-%I_%M_%S-%p").mkv
else
	ffmpeg \
		-f v4l2 -i $1 \
		-f pulse -i $2 \
		-b:v ${BITRATE}M -maxrate ${BITRATE}M -bufsize ${BUFSIZE}M \
		-preset veryfast -c:v libx264 -c:a libvorbis \
		-f matroska $3/recording-$(date "+%m_%d_%y-%I_%M_%S-%p").mkv
fi

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

