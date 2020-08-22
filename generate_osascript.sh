#!/bin/bash

OUTPUT="output"

function usage()
{
    echo "Shake your font !"
    echo ""
    echo "./generate_font.sh"
    echo "\t-h --help"
    echo "\t--output-dir=$OUTPUT"
    echo ""
}

while [ "$1" != "" ]; do
    PARAM=`echo $1 | awk -F= '{print $1}'`
    VALUE=`echo $1 | awk -F= '{print $2}'`
    case $PARAM in
        -h | --help)
            usage
            exit
            ;;
        --output-dir)
            OUTPUT=$VALUE
            ;;
        *)
            echo "ERROR: unknown parameter \"$PARAM\""
            usage
            exit 1
            ;;
    esac
    shift
done

mkdir -p $OUTPUT

# Remove first line of table and reverse it
tail -n +2 table.txt | tac > $OUTPUT/replace.scpt

# Replace "," separators by ") to "
# and handle special case concerning "," rules
sed -i '/,,/ ! s/,/") to "/g' $OUTPUT/replace.scpt
sed -i 's/^,,/,") to "/g' $OUTPUT/replace.scpt
sed -i 's/,,/") to ",/g' $OUTPUT/replace.scpt

# Replace line return by osascript replace code
sed -i ':a;$!{N;ba}; s/\n/"\n\tset (every character where it is "/g' $OUTPUT/replace.scpt
sed -i '1s/^/\tset (every character where it is "/' $OUTPUT/replace.scpt
sed -i '$s/$/"/' $OUTPUT/replace.scpt

# Escape specials char unsuported by osascript
sed -i 's/\\/\\\\/g' $OUTPUT/replace.scpt
sed -i 's/"""/"\\""/g' $OUTPUT/replace.scpt

# Add begining and end instructions
sed -i '1s/^/tell application "Pages" to tell the front document to tell the body text\n/' $OUTPUT/replace.scpt
echo -e 'end tell' >> $OUTPUT/replace.scpt