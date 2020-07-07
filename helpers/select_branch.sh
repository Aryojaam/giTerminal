#!/usr/bin/env bash
source ~/.giterminal/helpers/select_option.sh

function select_branch {
  echo "Select a branch to checkout"

  branches=$(ls -A $gitDirectoyPath/refs/heads/)

  options=($branches)

  select_option "${options[@]}"
  choice=$?

  git checkout "${options[$choice]}"
}