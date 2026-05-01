#!/usr/bin/env bash

export PATH=~/.local/bin:$PATH
export PATH=~/.local/mud/bin:$PATH

alias now="date +\"%Y-%m-%dT%H-%M-%SZ%z\""
alias jknow="date +\"%Y-%m-%d %H-%M-%S %z\""
alias today="date +\"%Y-%m-%d\""

if [[ -z $ssh_lock ]] then
  eval $(ssh-agent -s)
  ssh-add ~/.ssh/id_ed25519
  export ssh_lock=1
fi
