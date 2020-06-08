#!/usr/bin/env bash
source ~/giTerminal/helpers/select_option.sh
source ~/giTerminal/helpers/select_branch.sh

commands=('Select branch' 'Status')

function navigator {
  echo "What do you wanna do?"

  select_option "${commands[@]}"
  choice=$?

	case "$choice" in
		0) select_branch ;;
		1) eval "git status" ;;
	esac
}

navigator