#!/bin/bash


INPUT="input.ttf"
OUTPUT="output"
FONT_NAME="Shaked"

function usage()
{
    echo "Shake your font !"
    echo ""
    echo "./generate_font.sh"
    echo "\t-h --help"
    echo "\t--input-font=$INPUT"
    echo "\t--output-dir=$OUTPUT"
    echo "\t--font-name=$FONT_NAME"
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
        --input-font)
            INPUT=$VALUE
            ;;
        --output-dir)
            OUTPUT=$VALUE
            ;;
        --font-name)
            FONT_NAME=$VALUE
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

# Appply permutation to the font file
ttfremap -c change.txt -r -s $INPUT $OUTPUT/$FONT_NAME.ttf

# Extract font name from file
font_name=$(fc-scan $OUTPUT/$FONT_NAME.ttf | grep "fullname:" | cut -d '"' -f 2)

# Extract the font file to XML
ttx -o tmp.ttx $OUTPUT/$FONT_NAME.ttf
rm $OUTPUT/$FONT_NAME.ttf

# Replace font name
sed -i "s/$font_name/$FONT_NAME/g" tmp.ttx

# Re-build font file
ttx -o $OUTPUT/$FONT_NAME.ttf tmp.ttx
rm tmp.ttx