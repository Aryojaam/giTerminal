#!/usr/bin/env bash
source ~/.giterminal/helpers/select_option_mult.sh
: ' 
List of Functions and Variables defined somewhere else: 
	- select_option_mult 	From select_option_mult.sh  
'

function delete_multiple_branches {
  echo "Currenty on branch $(git rev-parse --abbrev-ref HEAD). Mark branches with Home-key and then press return to delete them"

  branches=$(ls -A $gitDirectoyPath/refs/heads/)
  options=($branches)

  select_option_mult "${options[@]}"
  for ((i=0;i<${#options[@]};i++)); do
    if [ ${marked[i]} = "1" ]; then
        git branch -D "${options[i]}"
    fi
  done
}