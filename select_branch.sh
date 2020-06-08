#!/usr/bin/env bash
source ./select_option.sh

arr=()

function select_branch {
  echo "Select a branch to checkout"

  branches=$(ls -A1 .git/refs/heads/)

  for line in "$branches"; do
		arr+=("$line")
  done

  options=($arr)

  select_option "${options[@]}"
  choice=$?

  git checkout "${options[$choice]}"
}

select_branch
