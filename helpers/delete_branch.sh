#!/usr/bin/env bash
source ~/.giterminal/helpers/select_option.sh

function delete_branch {
  echo "Currenty on branch $(git rev-parse --abbrev-ref HEAD). Select a local branch to delete"

  branches=$(ls -A $gitDirectoyPath/refs/heads/)

  options=($branches)

  select_option "${options[@]}"
  choice=$?

  git branch -D "${options[$choice]}"
}