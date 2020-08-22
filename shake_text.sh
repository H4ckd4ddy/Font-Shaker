#!/bin/bash

TABLE="table.txt"
TEXT="Hello world !!!"

function usage()
{
	echo -e "Shake your font !"
	echo -e ""
	echo -e "./shake_text.sh"
	echo -e "\t-h --help"
	echo -e "\t--table=$TABLE"
	echo -e "\t--text=$TEXT"
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
		--table)
			TABLE=$VALUE
			;;
		--text)
			TEXT=$VALUE
			;;
		*)
			echo "ERROR: unknown parameter \"$PARAM\""
			usage
			exit 1
			;;
	esac
	shift
done


if [ ! -f "$TABLE" ]; then
	echo "File $TABLE not found"
	exit
fi

result=""

# For each char
for (( i=0; i<${#TEXT}; i++ )); do
	# Select the original char
	char="${TEXT:$i:1}"
	# Seach the char in the permutation table
	if rule=$(grep -F -- "$char," $TABLE);then
		# Select the corresponding char in the rule
		corresponding="$(cut -d "," -f2 <<< "$rule" | tr -d '\n')"

		# Handle backslash special case
		#if [[ $corresponding == *'\'* ]]; then
		#  corresponding='\'
		#fi
	else
		# If char not found in permutation table, leave the original
		corresponding="$char"
	fi
	# Add char to the result string
	result="$result$corresponding"
done

echo "$result"