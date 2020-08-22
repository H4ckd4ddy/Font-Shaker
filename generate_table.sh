#!/bin/bash

OUTPUT="."

function usage()
{
    echo -e "Shake your font !"
    echo -e ""
    echo -e "./generate_table.sh"
    echo -e "\t-h --help"
    echo -e "\t--seed=$SEED"
    echo -e "\t--output=$OUTPUT"
    echo -e "\t--preserve-space=1"
    echo -e ""
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
        --output)
            OUTPUT=$VALUE
            ;;
        --preserve-space)
            SPACE=1
            ;;
        *)
            echo "ERROR: unknown parameter \"$PARAM\""
            usage
            exit 1
            ;;
    esac
    shift
done

if [ -z "$SEED" ];then
    echo "Error, please specify a seed"
    exit
fi

# Set seed in PRNG
RANDOM=$SEED


#####################
# If we need to handle more chars in the future
#####################
## Dump unicode range supported by font
#fc-match --format='%{charset}\n' calibri.ttf 
#
## Generate seq from hex range
#start=20
#stop=7e
#
#for i in $( seq $((16#$start)) $((16#$stop)) );do
#    echo $i
#done
#####################

# Make an array with all printable ascii code (from space to ~)
# (or from ! to ~ if we preserve space)
if [ -z "$SPACE" ];then
    avaiable_ascii_codes=($(seq 32 126))
else
    avaiable_ascii_codes=($(seq 33 126))
fi

size=${#avaiable_ascii_codes[@]}

# Chose a random charcode
chosen=$(($RANDOM % $size))
# Store it for the last permutation
first_selected_char=${avaiable_ascii_codes[$chosen]}
# Set it as first "previous"
previous=$first_selected_char
# Remove this charcode from array
avaiable_ascii_codes=( "${avaiable_ascii_codes[@]:0:$chosen}" "${avaiable_ascii_codes[@]:$((chosen+1))}" )

chr() {
  [ "$1" -lt 256 ] || return 1
  printf "\\$(printf '%03o' "$1")"
}

rm $OUTPUT/change.txt
rm $OUTPUT/table.txt

# For each remaining charcode in array
for (( i=0; i<$((size-1)); i++ ));do
	actual_size=${#avaiable_ascii_codes[@]}
	chosen=$(($RANDOM % $actual_size))
    # Add the permutation description in change file
    # as "the previous char become this random chosen char"
    # charcode are printed in hex
	echo "$( printf "%x" $previous ),$( printf "%x" ${avaiable_ascii_codes[$chosen]} )" >> $OUTPUT/change.txt
    # Add also char correspondance in a file
    echo "$(chr $previous ),$( chr ${avaiable_ascii_codes[$chosen]} )" >> $OUTPUT/table.txt
    # Set the new "previous"
	previous=${avaiable_ascii_codes[$chosen]}
    # Remove the char from array
	avaiable_ascii_codes=( "${avaiable_ascii_codes[@]:0:$chosen}" "${avaiable_ascii_codes[@]:$((chosen+1))}" )
done

# Write the last permutation, the last chosen char match the first one
echo "$( printf "%x" $previous ),$( printf "%x" $first_selected_char )" >> $OUTPUT/change.txt
echo "$( chr $previous ),$( chr $first_selected_char )" >> $OUTPUT/table.txt