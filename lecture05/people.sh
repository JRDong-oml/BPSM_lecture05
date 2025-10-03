#!/bin/bash
#Set tab delimiter
unset IFS
IFS=$'\t'
#Initialize counter
counter=0
rm -f *.test2
while read name email city day month year country
	do
		if test -z ${name}; then
			echo -e "line is blank"
		elif test ${country} == "country"; then
			echo -e "line is header"
		else
			counter=$((counter+1))
			echo "Country file is ${country// /_}.test2"
			echo -e "${counter}\t${name}\t${city}\t${country}">>./countries/${country// /_}.test2
		fi
	done < example_people_data.tsv