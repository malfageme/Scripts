#!/bin/bash
#######################################################
# Recode all audio files to MP3 CBR 128kbps
# Recursive script
# The original file is not erased, but if it is an mp3 file
# then it is replaced by the new reencoded file
#

BITRATE=128
FILE_TYPES="(\.mp3|\.mpc|\.wma|\.flac|\.ogg|\.m4a|\.ape)$"

LOGFILE="$PWD"/`basename $0`.log
WORK_DIR=/tmp/${BITRATE}_$$

touch "$LOGFILE"


mkdir -p $WORK_DIR
for f in *
  do
    if [ -d "$f" ]; then
      echo "Processing directory: $f"
      cd "$f"
      $0
      cd ..
      echo "Done with directory: $f"
    elif [[ "$f" =~ $FILE_TYPES ]]; then
      if ( mp3info  -r a -p "%r"  "$f" | cut -d. -f1 | grep "${BITRATE}" > /dev/null ); then
          echo "File: $f ---> Already ${BITRATE} kbps"
      else
          echo "File: $f"
          OUTPUT_FILE="${f%.*}".mp3
          ffmpeg -i "$f"  -ab ${BITRATE}k -ac 2 -ar 44100 -id3v2_version 3 "$WORK_DIR/$OUTPUT_FILE" >> "$LOGFILE" 2>&1
          mv "$WORK_DIR/$OUTPUT_FILE" .
      fi
    fi
done
rmdir $WORK_DIR

exit


