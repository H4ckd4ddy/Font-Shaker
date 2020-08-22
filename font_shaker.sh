#!/bin/bash

SEED=$(( $RANDOM % 10000 + 1 ))
INPUT="input.ttf"
OUTPUT="output"
FONT_NAME="Shaked"

function usage()
{
    echo "Shake your font !"
    echo ""
    echo "./font_shaker.sh"
    echo "\t-h --help"
    echo "\t--seed=$SEED"
    echo "\t--input-font=$INPUT"
    echo "\t--output-dir=$OUTPUT"
    echo "\t--font-name=$FONT_NAME"
    echo "\t--text=[Text to shake]"
    echo "\t--preserve-space"
    echo "\t--generate-osascript"
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
        --seed)
            SEED=$VALUE
            ;;
        --input-font)
            INPUT=$VALUE
            ;;
        --output-dir)
            OUTPUT=$VALUE
            ;;
        --font-name)
            FONT_NAME=$VALUE
            ;;
        --text)
            TEXT=$VALUE
            ;;
        --preserve-space)
            SPACE=1
            ;;
        --generate-osascript)
            OSASCRIPT=1
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

# Generate permutation table
if [ -z "$SPACE" ];then
    ./generate_table.sh --seed=$SEED &> /dev/null
else
    ./generate_table.sh --seed=$SEED --preserve-space &> /dev/null
    echo "Space preserved"
fi
echo "Permutation table generated !"

# Generate font
if [ -f "$INPUT" ]; then
    ./generate_font.sh --input-font=$INPUT --output-dir=$OUTPUT --font-name=$FONT_NAME &> /dev/null
    echo "Font file created !"
fi

# Shake text
if [ ! -z "$TEXT" ];then
    echo "Shaked text: "
    ./shake_text.sh --text="$TEXT"
fi

# Generate osascript
if [ ! -z "$OSASCRIPT" ];then
    ./generate_osascript.sh
    echo "Osascript generated !"
fi