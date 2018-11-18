#!/usr/bin/env bash

set -xueo pipefail

cd link

for dotfile in *
do
  if [[ -e ${HOME}/.${dotfile} ]]; then
    ln -sf ${PWD}/${dotfile} ${HOME}/.${dotfile}
  fi
done
