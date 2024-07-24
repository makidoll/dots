# Maki's keyboard config

Using CannonKeys Bakeneko60, layout inspired by POK3R

TODO: explain layout i guess

## QMK firmware

-   Clone [QMK](https://docs.qmk.fm/) and setup
-   Save [`keymap.c`](https://raw.githubusercontent.com/makidoll/dots/main/keyboard/keymap.c) to `keyboards/cannonkeys/db60/keymaps/maki/keymap.c`
-   Compile and flash

## Linux restore F13 to F24 keys

-   [`fix-fn-keys.sh`](https://raw.githubusercontent.com/makidoll/dots/main/keyboard/fix-fn-keys.sh)

## Play sound when layer switching

-   Add shortcuts in GNOME for 4 layers with command<br>
    `/home/maki/git/dots-maki/keyboard/play.sh <n>`
