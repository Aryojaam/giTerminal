#!/usr/bin/env bash
source ~/.giterminal/helpers/select_option.sh
source ~/.giterminal/helpers/select_branch.sh
source ~/.giterminal/helpers/select_remote_branch.sh
source ~/.giterminal/helpers/delete_branch.sh
source ~/.giterminal/helpers/commit_changes.sh

commands=('Select branch' 'Select remote branch' 'Delete branch' 'Commit changes' 'Status')

function navigator {
  echo "What do you wanna do?"

  select_option "${commands[@]}"
  choice=$?

	case "$choice" in
		0) select_branch ;;
		1) select_remote_branch ;;
		2) delete_branch ;;
		3) commit_changes ;;
		4) eval "git status" ;;
	esac
}

navigator