#!/bin/bash
v4l2-ctl --list-devices
echo
echo "-------"
echo
pactl list sources short | grep -v monitor | awk '{print $1,$2}'
echo
echo "-------"
echo

