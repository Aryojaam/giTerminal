#!/usr/bin/env bash
source ~/.giterminal/helpers/select_option.sh
source ~/.giterminal/helpers/select_branch.sh
source ~/.giterminal/helpers/select_remote_branch.sh
source ~/.giterminal/helpers/delete_branch.sh
source ~/.giterminal/helpers/delete_multiple_branches.sh
source ~/.giterminal/helpers/commit_changes.sh

# check if this repository is a git repository
if ! [ $(git rev-parse --is-inside-work-tree 2>/dev/null) ]; then
  echo "This is not a git repository. Exiting... Bye :("
  exit;
fi

# set the path for .git folder of the project
export gitDirectoyPath=`git rev-parse --git-dir`

# select_option columns
export columns=3
# trap 'clear"' SIGWINCH

commands=(
	'Select branch' 'Select remote branch' 'Delete branch'
	'Delete multiple branches' 'Commit changes' 'Status'
)

function navigator {
  echo "What do you wanna do?"

  select_option "${commands[@]}"
  choice=$?

	case "$choice" in
		0) select_branch ;;
		1) select_remote_branch ;;
		2) delete_branch ;;
		3) delete_multiple_branches ;;
		4) commit_changes ;;
		5) eval "git status" ;;
	esac
}

navigator