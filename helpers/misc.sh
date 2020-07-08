#!/usr/bin/env bash

function addWordPadding {
  for ((i=0;i<$1;i++)); do
    printf " "
  done
}

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

print_empty_rows() {
	rows=$1
	while [ $rows -ne 0 ]; do
		printf "\n"
		((rows--))
	done
}