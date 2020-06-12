#!/usr/bin/env bash
source ~/giTerminalExecutables/helpers/select_option.sh

function delete_branch {
  echo "Select a local branch to delete"

  branches=$(ls -A .git/refs/heads/)

  options=($branches)

  select_option "${options[@]}"
  choice=$?

  git branch -D "${options[$choice]}"
}