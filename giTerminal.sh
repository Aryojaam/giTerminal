#!/usr/bin/env bash
source ~/giTerminal/helpers/select_option.sh
source ~/giTerminal/helpers/select_branch.sh
source ~/giTerminal/helpers/select_remote_branch.sh

commands=('Select branch' 'Select remote branch' 'Status')

function navigator {
  echo "What do you wanna do?"

  select_option "${commands[@]}"
  choice=$?

	case "$choice" in
		0) select_branch ;;
		1) select_remote_branch ;;
		2) eval "git status" ;;
	esac
}

navigator