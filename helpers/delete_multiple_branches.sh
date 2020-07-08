#!/usr/bin/env bash
function addWordPadding {
  for ((i=0;i<$1;i++)); do
    printf " "
  done
}

# create an arrays of 0s with the same length as the parameters. The purpose is to save the marked elements.
marked=()

init_marked_array(){
  for i in "$@"
  do
      marked+=(0)
  done
}

columns=3
# The function cannot be extracted into own file because returning an array in a function between files is a PAIN!!
# credits to https://unix.stackexchange.com/a/415155
function select_option_mult {

	# little helpers for terminal print control and key input
	ESC=$( printf "\033")
	cursor_blink_on()  { printf "$ESC[?25h"; }
	cursor_blink_off() { printf "$ESC[?25l"; }
	cursor_to()        { printf "$ESC[$1;${2:-1}H"; }
	print_option()     { printf "   $1 "; }
	print_marked()     { printf "  *$1 "; }
	print_marked_selected()   { printf "  $ESC[7m*$1 $ESC[27m"; }
	print_selected()   { printf "  $ESC[7m $1 $ESC[27m"; }
	get_cursor_row()   { IFS=';' read -sdR -p $'\E[6n' ROW COL; echo ${ROW#*[}; }
	key_input()        { read -s -n3 key 2>/dev/null >&2
						 if [[ $key = $ESC[A ]]; then echo up;    fi
						 if [[ $key = $ESC[B ]]; then echo down;  fi
						 if [[ $key = $ESC[C ]]; then echo right;  fi
						 if [[ $key = $ESC[D ]]; then echo left;  fi
						 if [[ $key = $ESC[H ]]; then echo home;  fi
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
  echo "Mark branches with Home-key and then press return to delete them"

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