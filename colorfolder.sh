#!/bin/bash
# (c) 2006-2017 Daniel Faust - hessijames@gmail.com
# This file is published under the terms of the GPL
#
# v. 2.0.2
#
# how to use:
# remove icon from .directory file: colorfolder remove /your/directory
# set red folder icon: colorfolder folder-red /your/directory

DEBUG=0 # set to 1 in order to print debug messages to the log file
LOGFILE="~/color_folder.log"

function log {
  if [ $DEBUG != 0 ]; then
    echo "$(date) color folder: $1" >> $LOGFILE
  fi
}

SPLINTERLIST=""

for SPLINTER in $@; do

  log "new splinter: "$SPLINTER

  if [ "$SPLINTER" == "$1" ]
    then
      log "ignoring splinter!"
      continue
  fi

  if ! [[ $SPLINTER =~ /\.directory$ ]]
    then
      log ".directory file not found"
      log "adding path to splinterlist"
      if [ "$SPLINTERLIST" != "" ]
        then
          SPLINTERLIST="$SPLINTERLIST $SPLINTER"
        else
          SPLINTERLIST=$SPLINTER
      fi
      log "splinterlist: $SPLINTERLIST"
      continue
    else
      log ".directory file found"
      log "file must be splinterlist+splinter"
      if [ "$SPLINTERLIST" != "" ]
        then
          FILE="$SPLINTERLIST $SPLINTER"
          SPLINTERLIST=""
        else
          FILE=$SPLINTER
      fi
  fi

  log "file: $FILE"

  if [ -e "$FILE" ]
    then
      log "$FILE exits!"
      if [ "$1" == "remove" ]
        then
          sed "s/Icon=.*/#&/g" "$FILE" > "/tmp/$$" && mv "/tmp/$$" "$FILE"
          log "$FILE removed!"
        else
          FIND=`grep -e "Icon=.*" "$FILE"`
          if [ "$FIND" != "" ]
            then
              sed "s/#*Icon=.*/Icon=$1/g" "$FILE" > "/tmp/$$" && mv "/tmp/$$" "$FILE"
              log "$FILE modified! (replaced)"
            else
              echo "Icon=$1" >> "$FILE"
              log "$FILE modified! (added)"
          fi
      fi
    else
      log "$FILE doesn't exist!"
      if [ "$1" != "remove" ]
        then
          echo "[Desktop Entry]" > "$FILE"
          echo "Icon=$1" >> "$FILE"
          log "$FILE created!"
      fi
  fi

done

