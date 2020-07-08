#!/usr/bin/env bash

function addWordPadding {
  for ((i=0;i<$1;i++)); do
    printf " "
  done
}

# Renders a text based list of options that can be selected by the
# user using up, down and enter keys and returns the chosen option.
#
#   Arguments   : list of options, maximum of 256
#                 "opt1" "opt2" ...
#   Return value: selected index (0 for opt1, 1 for opt2 ...)
# credits to https://unix.stackexchange.com/a/415155
columns=3
function select_option {

	# little helpers for terminal print control and key input
	ESC=$( printf "\033")
	cursor_blink_on()  { printf "$ESC[?25h"; }
	cursor_blink_off() { printf "$ESC[?25l"; }
	cursor_to()        { printf "$ESC[$1;${2:-1}H"; }
	print_option()     { printf "   $1 "; }
	print_selected()   { printf "  $ESC[7m $1 $ESC[27m"; }
	get_cursor_row()   { IFS=';' read -sdR -p $'\E[6n' ROW COL; echo ${ROW#*[}; }
	key_input()        { read -s -n3 key 2>/dev/null >&2
						 if [[ $key = $ESC[A ]]; then echo up;    fi
						 if [[ $key = $ESC[B ]]; then echo down;  fi
						 if [[ $key = $ESC[C ]]; then echo right;  fi
						 if [[ $key = $ESC[D ]]; then echo left;  fi
						 if [[ $key = ""     ]]; then echo enter; fi; }

	# initially print empty new lines (scroll down if at bottom of screen)
	# for opt; do printf "\n"; done
    longestWord=0
	rows=$((($columns - 1 + $#) / $columns))
	while [ $rows -ne 0 ]; do
		printf "\n"
		((rows--))
	done

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

			if [ $idx -eq $selected ]; then
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
