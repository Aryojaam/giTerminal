#!/usr/bin/env bash
source ~/giTerminalExecutables/helpers/select_option.sh
source ~/giTerminalExecutables/helpers/select_branch.sh
source ~/giTerminalExecutables/helpers/select_remote_branch.sh
source ~/giTerminalExecutables/helpers/delete_branch.sh
source ~/giTerminalExecutables/helpers/commit_changes.sh

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