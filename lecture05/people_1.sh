#!/bin/bash
#Set tab delimiter
unset IFS
IFS=$'\t'
#Initialize counter
counter=0
while read name email city day month year country
	do
		if test -z ${name}; then
			echo -e "line is blank"
		elif test ${country} == "country"; then
			echo -e "line is header"
		else
			counter=$((counter+1))
			echo -e "${counter}\tcountry is ${country}"
		fi
	done < example_people_data.tsv