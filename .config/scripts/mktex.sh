#!/usr/bin/env bash
#Useage: mktex FILENAME
#Opens a TeX file in nvim on space 5 and creates an empty PDF that is then opened in Skim
#When calling this script automatically it makes sense to emply another script that
#executes this one from a notes directory and provides date and time for filename

if [ $# -eq 0 ]; then
    osascript -e 'display notification "no filename specified" with title "Woops!"'
    exit 1
fi

query=$(yabai -m query --windows --space fifth | jq -r 'select(length>0)')
cur=$(pwd)
if [ -z "${query}" ]; then
    yabai -m space --focus fifth
    osascript -e 'tell application "iTerm2"' -e 'set newWindow to (create window with default profile)' -e 'tell current session of newWindow' -e 'write text "cd '"$cur"' && nvim -c '"NeoTexOn"' '"$1"'.tex"' -e 'end tell' -e 'end tell'
    convert xc:none -page A4 $1.pdf
    ~/.config/scripts/openPdf.sh $1.pdf
else
    osascript -e 'display notification "the space reserved for TeX-editing + PDF viewer was not empty" with title "Woops!"'
fi
