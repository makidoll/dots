#!/bin/bash

DIR=$(realpath "$(dirname "${BASH_SOURCE[0]}")")

ffplay -volume 20 -autoexit -nodisp $DIR/$1.mp3