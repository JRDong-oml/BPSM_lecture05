#!/bin/bash
#Reset field separator and set to tab
unset IFS
IFS=$'\t'
rm -f *.txt
#Create new step
counter=0
counter_a=0
while read Accession Subject PercentIdentity AlignmentLength Mismatches GapOpens QueryStart QueryEnd SubjectStart SubjectEnd EValue BitScore
do
	#List subject accessions for all HSP
	echo -e "${Subject}">>HSPAccessions.txt
	#List alignment length and percent identity for all HSP
	echo -e "Alignment Length: ${AlignmentLength}\t %ID: ${PercentIdentity}">>HSPAlign.txt
	if test ${Mismatches}>20; then
		#List all HSPs with more than 20 mismatches
		echo -e "${Subject} has more than 20 mismatches">>Mismatch.txt
		if  ((AlignmentLength < 100 )); then
			#subif for all HSPs that also have less than 100 aa length
			echo -e "${Subject} has more than 2- mismatches and is less than 100aa">>ShortMismatch.txt
		fi
	fi
	if test ${counter}<20 && test ${Mismatches}<20; then
		#List first 20 good matches using a counter
		echo -e "${counter}\t${Subject} has less than 20 mismatches">>GoodMatches.txt
		counter=$((counter+1))
	fi
	#Count the number of sequences that are shorter than 100 aa
	if  ((AlignmentLength < 100 )); then
		counter_a=$((counter_a+1))
	fi
	#List start positions where subject accession contains AEI
	if [[ ${Subject} == *"AEI"* ]]; then
		echo -e "${Subject}\t accession contains AEI and start position is ${SubjectStart}">>AEI.txt
	fi
	#Percentage of HSP are mismatches
	if ((AlignmentLength > 0 ));then
		MismatchRate=$(echo "scale=3;$Mismatches/$AlignmentLength" | bc)
		MismatchPercent=$(echo "scale=3;$MismatchRate*100" | bc)
		echo -e "${Subject} HSP has a mismatch percent of ${MismatchPercent}">>MismatchPercent.txt
	fi
	#Group HSPs based on BitScore arbitrary
	if test ${BitScore}>400; then
		echo -e "${Subject}">>HighScore.txt
	elif test ${BitScore}>300; then
		echo -e "${Subject}">>MidScore.txt
	else
		echo -e "${Subject}">>LowScore.txt
	fi
done < blastoutput2.out
