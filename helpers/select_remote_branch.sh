#!/usr/bin/env bash
source ~/.giterminal/helpers/select_option.sh

function select_remote_branch {
  echo "fetching all remotes please wait..."
  git fetch --all -q

  echo "Select a remote"
  remotes=$(ls -A $gitDirectoyPath/refs/remotes/)

  options=($remotes)
  
  select_option "${options[@]}"
  choice=$?

  branches=$(ls -A $gitDirectoyPath/refs/remotes/"${options[$choice]}")
  echo "Select a branch"
 
  branchOptions=($branches)

  select_option "${branchOptions[@]}"
  branchChoice=$?

  git checkout "${branchOptions[$branchChoice]}"
}