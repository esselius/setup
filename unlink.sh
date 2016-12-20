#!/usr/bin/env bash

set -xueo pipefail

cd link

for dotfile in *
do
	if [[ -h ${HOME}/.${dotfile} ]]; then
		unlink ${HOME}/.${dotfile}
	fi
done
