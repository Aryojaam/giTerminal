#!/usr/bin/env bash
source ~/.giterminal/helpers/select_option_mult.sh
source ~/.giterminal/helpers/colors.sh

: ' 
List of Functions and Variables defined somewhere else: 
	- select_option_mult 	From select_option_mult.sh  
  - marked              From select_option_mult.sh and array containing a binary array of options. 1 is for marked 0 is for unmarked
	- color functions		  From colors.sh
'

function delete_multiple_branches {
	echo "Currenty on branch $(cyan $(git rev-parse --abbrev-ref HEAD)). Mark branches with Space-key and then press return to delete them"

	branches=$(ls -A $gitDirectoyPath/refs/heads/)
	options=($branches)

	select_option_mult "${options[@]}"
	for ((i=0;i<${#options[@]};i++)); do
		if [ ${marked[i]} = "1" ]; then
			git branch -D "${options[i]}"
		fi
	done
}
