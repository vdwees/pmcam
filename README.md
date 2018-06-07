# pmcam - poor man's photo capture with motion detection in Bash

Forked from Laurent Cozic's webcam version: https://github.com/laurent22/pmcam

WARNING: This repo is a bit of an experiment/work-in-progress for now.

This simple Bash script captures images from a DSLR with motion detection support. Frames are captured at regular intervals using `gphoto2`. Then ImageMagick's `compare` tool is used to check if this frame is similar to the previous one. If the frames are different enough, we fire the DSLR. This provides very simple motion detection and avoids filling up the hard drive with duplicate frames.

## Installation

### OS X

	brew install gphoto2
	brew install imagemagick
	curl -O https://raw.github.com/vdwees/pmcam/master/pmcam.sh

### Linux (Debian)

	sudo apt-get install gphoto2
	sudo apt-get install imagemagick
	curl -O https://raw.github.com/vdwees/pmcam/master/pmcam.sh

## Usage

	./pmcam.sh

The script will use the default gphoto2 DLSR to capture frames.

To stop the script, press Ctrl + C.

## License

MIT
