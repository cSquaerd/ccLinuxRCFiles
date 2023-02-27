#!/bin/bash
v4l2-ctl --list-devices
echo
echo "-------"
echo
pactl list sources short
echo
echo "-------"
echo

