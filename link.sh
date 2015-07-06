#!/usr/bin/env bash

set -xueo pipefail

cd link

for dotfile in *
do
  ln -sf ${PWD}/${dotfile} ${HOME}/.${dotfile}
done
