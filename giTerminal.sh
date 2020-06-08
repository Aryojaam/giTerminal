#!/usr/bin/env bash
source ./select_option.sh
source ./select_branch.sh

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