#!/bin/bash

function get-images-in-source {
	\ls $SOURCE_DIR/*.png $SOURCE_DIR/*.jpg $SOURCE_DIR/*.gif 2>/dev/null
}

function count-images-in-source {
	get-images-in-source | wc -l
}

SOURCE_DIR=$1
DEST_DIR=$2

if [[ ! -d $SOURCE_DIR ]]; then
	echo "ERROR: Source directory does not exist! Exiting..."
	exit -1
elif (( $(count-images-in-source) == 0 )); then
	echo "ERROR: Source directory has no images to move! Exiting..."
	exit -2
fi

function list-sorting-dirs {
	DIRS=($@)
	if (( ${#DIRS[@]} == 0 )); then
		echo "Warning: No dirs provided."
		return
	fi

	N=0
	echo
	for DIR in ${DIRS[@]}; do
		echo $N" "$DIR
		(( N = $N + 1 ))
	done
	echo
}

if [[ ! -d $DEST_DIR ]]; then mkdir -p $DEST_DIR; fi

SORTING_DIRS=()
for DIR in $DEST_DIR/*/; do
	SORTING_DIRS+=($DIR)
done

while (( $(count-images-in-source) > 0 )); do
	NEXT_IMAGE=$(get-images-in-source | head -n 1)
	magick display -sample x480 $NEXT_IMAGE &
	DISPLAY_PID=$!
	PROCESSED=0
	while (( ! $PROCESSED )); do
		list-sorting-dirs ${SORTING_DIRS[@]}
		echo "Enter the number of the directory to move this picture into,"
		echo "Or press 'n' to make a new directory, which the picture will be moved into."
		echo -n ">"
		read ENTRY
		if [[ $ENTRY == "n" ]]; then
			NEW_DIR_CREATED=0
			while (( ! $NEW_DIR_CREATED )); do
				echo
				echo "Enter the name of the new directory (folder) to create"
				echo -n ">"
				read NEW_DIR_NAME
				if [[ -d $DEST_DIR/$NEW_DIR_NAME ]]; then
					echo
					echo "ERROR: That directory already exists, please re-enter."
				else
					mkdir -p $DEST_DIR/$NEW_DIR_NAME
					SORTING_DIRS+=($DEST_DIR/$NEW_DIR_NAME)
					mv -n $NEXT_IMAGE $DEST_DIR/$NEW_DIR_NAME/.
					NEW_DIR_CREATED=1
					PROCESSED=1
				fi
			done
		else
			TARGET_DIR=${SORTING_DIRS[$ENTRY]}
			mv -n $NEXT_IMAGE $TARGET_DIR/.
			PROCESSED=1
		fi
	done
	kill $DISPLAY_PID
done

