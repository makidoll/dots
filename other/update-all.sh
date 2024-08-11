#!/bin/bash

export MAKEFLAGS="-j32"

ignore=()

ignore_args=""

for package in "${ignore[@]}"
do
	ignore_args="$ignore_args --ignore $package"
done

# echo $ignore_args

sudo pacman -Syu $ignore_args

if [[ "$1" != "--noaur" ]]; then
	# yay -Syu --noconfirm $ignore_args
	yay -Syu $ignore_args
fi
