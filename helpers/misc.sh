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
# https://stackoverflow.com/a/11759139
key_input() { 
  read -sN1 key # 1 char (not delimiter), silent
  # catch multi-char special key sequences
  read -sN1 -t 0.0001 k1
  read -sN1 -t 0.0001 k2
  read -sN1 -t 0.0001 k3
  key+=${k1}${k2}${k3}

  case "$key" in
    x|y|$'\e[D')  # cursor left
      echo left;;

    x|y|$'\e[A')  # cursor up
      echo up;;

    x|y|$'\e[B')  # cursor down
      echo down;;

    x|y|$'\e[C')  # cursor right
      echo right;;

    x|y|$'\n') # return character
      echo enter;;
    ' ')  # space: mark/unmark item
      echo space;;
  esac
}

print_empty_rows() {
	rows=$1
	while [ $rows -ne 0 ]; do
		printf "\n"
		((rows--))
	done
}
