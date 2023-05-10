#!/bin/bash

function get-images-in-source {
	\ls $SOURCE_DIR/*.png $SOURCE_DIR/*.jpg $SOURCE_DIR/*.gif
}

function count-images-in-source {
	$(get-images-in-source) | wc -l
}

SOURCE_DIR=$1
DEST_DIR=$2

if [[ ! -d $SOURCE_DIR ]]; then
	echo "ERROR: Source directory does not exist! Exiting..."
	exit -1
else if (( $(count-images-in-source) == 0 )); then
	echo "ERROR: Source directory has no images to move! Exiting..."
	exit -2
fi

function list-sorting-dirs {
	DIRS=$1
	if (( ${#DIRS[@]} == 0 )); then
		echo "Warning: No dirs provided."
		return
	fi

	N=0
	for DIR in ${DIRS[@]}; do
		echo $N" "$DIR
	done
}

if [[ ! -d $DEST_DIR ]]; then mkdir -p $DEST_DIR; fi

SORTING_DIRS=()
for DIR in $DEST_DIR/*/; do
	SORTING_DIRS+=(DIR)
done

while (( $(count-images-in-source) > 0 )); do
	NEXT_IMAGE=$(get-images-in-source | head -n 1)


done
