#!/usr/bin/env bash
: ' 
List of Functions and Variables defined somewhere else: 
	- gitDirectoyPath 		From giterminal.sh [exported variable] 
	- columns 				From giterminal.sh [exported variable] 
	- ESC					From misc.sh
	- cursor_blink_on		From misc.sh
	- cursor_blink_off		From misc.sh
	- cursor_to				From misc.sh
	- print_option			From misc.sh
	- print_selected		From misc.sh
	- get_cursor_row		From misc.sh
	- key_input				From misc.sh
	- print_empty_rows		From misc.sh
'
source ~/.giterminal/helpers/misc.sh

# create an arrays of 0s with the same length as the parameters. The purpose is to save the marked elements.
marked=()

init_marked_array() {
  for i in "$@"
  do
      marked+=(0)
  done
}

# $columns is an exported variable in giterminal.sh
# The function cannot be extracted into own file because returning an array in a function between files is a PAIN!!
# Idea: extract the function into a file, set the array variable in file 
# and then reference it from the caller file and see if the value is there.
# credits to https://unix.stackexchange.com/a/415155
function select_option_mult {

	# initially print empty new lines (scroll down if at bottom of screen)
    longestWord=0
	rows=$((($columns - 1 + $#) / $columns))
	print_empty_rows $rows 


	# find the longest word within the options
	for opt; do
		if [ ${#opt} -ge $longestWord ]; then
			longestWord=${#opt};
		fi
	done

	# determine current screen position for overwriting the options
	local lastrow=`get_cursor_row`
	local startrow=$((lastrow - (columns - 1 + $#) / columns))

	# ensure cursor and input echoing back on upon a ctrl+c during read -s
	trap "cursor_blink_on; stty echo; printf '\n'; exit" 2
	cursor_blink_off

	local selected=0
	while true; do
		# print options by overwriting the last lines
		local idx=0
    	# navigate to the starting row to overwrite the lines
    	cursor_to $((startrow))

		for opt; do
      		# Check if should go to the next row
			if ! ((idx % columns)); then
				cursor_to $((startrow + idx / columns))
			fi
			
			if [ $idx -eq $selected ] && [ "${marked[$idx]}" -eq "1" ]; then
				print_marked_selected "$opt"
				addWordPadding $((longestWord-${#opt}))
			elif [ "${marked[$idx]}" -eq "1" ]; then
				print_marked "$opt"
				addWordPadding $((longestWord-${#opt}))
			elif [ $idx -eq $selected ]; then
				print_selected "$opt"
				addWordPadding $((longestWord-${#opt}))
			else
				print_option "$opt"
				addWordPadding $((longestWord-${#opt}))
			fi

			((idx++))
		done

		# user key control
		case `key_input` in
			enter) break;;
			home) marked[$selected]=$(( (marked[selected] + 1) % 2 ));;
			up)    
				if [ $((selected - columns)) -ge 0 ];
				then selected=$((selected-=columns));
				fi;; 
			right)  
				if [[ $((selected % columns)) -ne $((columns - 1)) ]] &&
					[[ $((selected + 1)) -ne $# ]];
				then ((selected++));
				fi;;
			down)  ((selected+=columns));
        		if [ $selected -ge $# ]; then selected=$((selected % columns)); fi;;
			left)
        		if [ $((selected % columns)) -ne 0 ]; then ((selected--)); fi;;
		esac
		
	done

	# cursor position back to normal
	cursor_to $lastrow
	printf "\n"
	cursor_blink_on

	return $selected
}

function delete_multiple_branches {
  echo "Currenty on branch $(git rev-parse --abbrev-ref HEAD). Mark branches with Home-key and then press return to delete them"

  branches=$(ls -A $gitDirectoyPath/refs/heads/)
  options=($branches)

  # init the marked array with the number of elements before choosing
  init_marked_array "${options[@]}"

  select_option_mult "${options[@]}"
  for ((i=0;i<${#options[@]};i++)); do
    if [ ${marked[i]} = "1" ]; then
        git branch -D "${options[i]}"
    fi
  done
}