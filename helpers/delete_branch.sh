#!/usr/bin/env bash
source ~/.giterminal/helpers/select_option.sh
branch_font=$( printf "\x1b[36;1m")
normal_font=$( printf "\033[m" )

function delete_branch {
  echo "Currenty on branch $branch_font$(git rev-parse --abbrev-ref HEAD)$normal_font. Select a local branch to delete"

  branches=$(ls -A $gitDirectoyPath/refs/heads/)

  options=($branches)

  select_option "${options[@]}"
  choice=$?

  git branch -D "${options[$choice]}"
}