#!/usr/bin/env bash
source ./select_option.sh

function select_branch {
  echo "Select a branch to checkout"

  branches=$(ls -A .git/refs/heads/)

  options=($branches)

  select_option "${options[@]}"
  choice=$?

  git checkout "${options[$choice]}"
}
