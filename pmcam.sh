#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
OUTPUT_DIR="$SCRIPT_DIR/images"

CAPTURE_INTERVAL="0.3" # in seconds
DIFF_RESULT_FILE=$OUTPUT_DIR/tmp/diff_results.txt

fn_terminate_script() {
	rm -rf $OUTPUT_DIR/tmp
	echo "SIGINT caught."
	exit 0
}
trap 'fn_terminate_script' SIGINT

mkdir -p $OUTPUT_DIR
mkdir -p $OUTPUT_DIR/tmp

PREVIOUS_FILENAME=""
while true ; do
	TIMESTAMP="$(date +"%Y%m%dT%H%M%S%N")"
	FILENAME="$OUTPUT_DIR/thumb_$TIMESTAMP.jpg"
	echo "-----------------------------------------"
	echo "Capturing $FILENAME"
	gphoto2 --capture-preview --filename="$OUTPUT_DIR/$TIMESTAMP.jpg"
	
	if [[ "$PREVIOUS_FILENAME" != "" ]]; then
		# For some reason, `compare` outputs the result to stderr so
		# it's not possibly to directly get the result. It needs to be
		# redirected to a temp file first.
		compare -fuzz 20% -metric ae $PREVIOUS_FILENAME $FILENAME $OUTPUT_DIR/tmp/diff.png 2> $DIFF_RESULT_FILE
		DIFF="$(cat $DIFF_RESULT_FILE)"
		rm -f $DIFF_RESULT_FILE
		if [ "$DIFF" -lt 800 ]; then
			echo "Same as previous image: delete (Diff = $DIFF)"
			rm -f $FILENAME $OUTPUT_DIR/tmp/diff.png
		else
			echo "Different image: keep, grab HQ version (Diff = $DIFF)"
			mv $OUTPUT_DIR/tmp/diff.png "$OUTPUT_DIR/$TIMESTAMP-diff.png"
			gphoto2 --capture-image-and-download --filename="$OUTPUT_DIR/$(date +"%Y%m%dT%H%M%S%N")_%03n.jpg"
			PREVIOUS_FILENAME="$FILENAME"
		fi
	else
		PREVIOUS_FILENAME="$FILENAME"
	fi
	
	sleep $CAPTURE_INTERVAL
done
