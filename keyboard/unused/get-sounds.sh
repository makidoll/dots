#!/bin/bash

source ~/venv/bin/activate

pip install gtts

gtts-cli -l ja -o _1.mp3 typing
gtts-cli -l ja -o _2.mp3 arrow
gtts-cli -l ja -o _3.mp3 gaming
gtts-cli -l ja -o _4.mp3 "arrow gaming"

# crunch and trim

AUDIO_FILTER="silenceremove=1:0:-50dB,atempo=1.3"

ffmpeg -y -i _1.mp3 -ar 22050 -af $AUDIO_FILTER 1.mp3
ffmpeg -y -i _2.mp3 -ar 22050 -af $AUDIO_FILTER 2.mp3
ffmpeg -y -i _3.mp3 -ar 22050 -af $AUDIO_FILTER 3.mp3
ffmpeg -y -i _4.mp3 -ar 22050 -af $AUDIO_FILTER 4.mp3

# clean up

rm -f _1.mp3
rm -f _2.mp3
rm -f _3.mp3
rm -f _4.mp3