# Maki's Extras for Arch

-   refresh your mirrorlist

    `sudo reflector --country US --latest 25 --score 25 --sort rate --protocol https --verbose --save /etc/pacman.d/mirrorlist`

-   install yay aur helper

    ```
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
    ```

-   gnome recommendations

    -   use fixed number of workspaces to 8 in **Settings > Multitasking > Workspaces**

    -   update keybinds in **Settings > Keyboard > View and Customize Shortcuts**

        -   under `Naviation`

            -   `Move window one workspace to the left` to **Shift + Super + Q**
            -   `Move window one workspace to the right` to **Shift + Super + E**
            -   `Switch applications` to **Disabled**
            -   `Switch to workspace on the left` to **Super + Q**
            -   `Switch to workspace on the right` to **Super + E**
            -   ❗ `Switch windows` to **Alt + Tab**

        -   under `System`

            -   `Show all apps` to **Disabled**
            -   `Show the run command prompty` to **Alt + F12**

        -   under `Custom`
            -   `Open terminal` with `gnome-terminal` to **Alt + Return**
            -   `Playerctl next` with `playerctl next` to **Audio next**
            -   `Playerctl play/pause` with `playerctl play-pause` to **Audio play**
            -   `Playerctl previous` with `playerctl previous` to **Audio previous**

    -   using tweaks, disable **Middle Click Paste** in **Keyboard & Mouse**

    -   if using 800 dpi for mouse, half sensitivity and disable mouse acceleration<br>
        `gsettings set org.gnome.desktop.peripherals.mouse speed -0.5`<br>
        `gsettings set org.gnome.desktop.peripherals.mouse accel-profile flat`

    -   resize windows using mod+rmb<br>
        `gsettings set org.gnome.desktop.wm.preferences resize-with-right-button true`

    -   incase `file://` uris dont open in gnome nautilus

        `xdg-mime default org.gnome.Nautilus.desktop inode/directory`

    -   themes

        -   please dont theme gnome
        -   but do use [Papirus Icon Theme](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme)

    -   extensions

        recommended to install below using yay (cause devs arent updating their extensions on gnome.org)

        `yay -S --noconfirm gnome-shell-extension-appindicator-git gnome-shell-extension-freon gnome-shell-extension-gamemode-git gnome-shell-extension-hidetopbar-git gnome-shell-extension-rounded-window-corners-git gnome-shell-extension-arch-update`

        -   [AppIndicator and KStatusNotifierItem Support](https://extensions.gnome.org/extension/615/appindicator-support/) adds tray icons back
        -   [Freon](https://extensions.gnome.org/extension/841/freon/) shows cpu temp and more
        -   [GameMode](https://extensions.gnome.org/extension/1852/gamemode/) shows indicator when `gamemoderun`
        -   [Hide Top Bar](https://extensions.gnome.org/extension/545/hide-top-bar/) gives back space
        -   [Rounded Window Corners](https://extensions.gnome.org/extension/5237/rounded-window-corners/) is just nice
        -   [Arch Update Indicator](https://extensions.gnome.org/extension/1010/archlinux-updates-indicator/) shows package updates

            -   In advanced settings, change command to check for package updates:<br>
                `/bin/sh -c "/usr/bin/checkupdates && /usr/bin/yay -Qua"`
            -   Command to update packages:<br>
                `gnome-terminal -- /bin/sh -c "~/update-all.sh; echo Done - Press enter to exit; read _"`
            -   In home folder, write `update-all.sh`:<br>

                ```bash
                #!/bin/bash

                export MAKEFLAGS="-j32" # please use `nproc --all`

                ignore=()

                ignore_args=""
                for package in "${ignore[@]}"
                do
                    ignore_args="$ignore_args --ignore $package"
                done

                # echo $ignore_args

                if [[ "$1" == "--pacman" ]]; then
                    sudo pacman -Syu $ignore_args
                else
                    yay -Syu $ignore_args
                fi
                ```

        honorable but not using

        -   [Dash to Panel](https://extensions.gnome.org/extension/1160/dash-to-panel/)
        -   [Dash to Dock](https://extensions.gnome.org/extension/307/dash-to-dock/)
        -   [Vertical overview](https://extensions.gnome.org/extension/4144/vertical-overview/)
        -   [Grand Theft Focus](https://extensions.gnome.org/extension/5410/grand-theft-focus/) brings ready windows into focus

-   firefox with vertical tabs

    -   install [sideberry](https://addons.mozilla.org/en-US/firefox/addon/sidebery/) extension
    -   css hack [to hide native tabs](<https://github.com/mbnuqw/sidebery/wiki/Firefox-Styles-Snippets-(via-userChrome.css)#completely-hide-native-tabs-strip>)
    -   also add `#sidebar-header { display: none; }`
    -   install [`minimalist-dracula-darker.xpi`](https://github.com/makidoll/dots/blob/main/other/minimalist-dracula-darker.xpi) theme (modified from [MinimalistFox](https://github.com/canbeardig/MinimalistFox))

-   setup deadbeef

    -   `yay -S deadbeef-git deadbeef-mpris2-plugin deadbeef-plugin-fb-gtk3-git deadbeef-plugin-spectrogram-gtk3-git deadbeef-plugin-discord-git`
    -   [`.config/deadbeef/config`](https://raw.githubusercontent.com/makidoll/dots/main/.config/deadbeef/config)

-   force microphone to fixed volume using wireplumber and systemd

    -   ```bash
        wget https://raw.githubusercontent.com/makidoll/dots/main/other/fix-mic-volume.lua
        chmod +x fix-mic-volume.lua
        ```

    -   update variables at the top of the lua file

    -   `vim ~/.config/systemd/user/fix-mic-volume.service`

        ```
        [Unit]
        Description=Fix Mic Volume

        [Service]
        ExecStart=/home/maki/fix-mic-volume.lua
        Type=simple
        # treat as a lowest priority program
        Nice=19

        [Install]
        WantedBy=default.target
        ```

    -   `systemctl enable --now --user fix-mic-volume.service`
    -   `systemctl status --user fix-mic-volume.service` make sure its not erroring

-   set cpu frequency policy to performance

    -   install cpupower `sudo pacman -S cpupower`
    -   check available governors and current policy `cpupower frequency-info`
    -   modify `/etc/default/cpupower` and set governer to `performance`
    -   enable and start systemd service `sudo systemctl enable --now cpupower`
    -   check if policy was updated `cpupower frequency-info`

    find more info here https://wiki.archlinux.org/title/CPU_frequency_scaling#cpupower

-   TODO: linux-tkg

-   disable `*-debug` packages

    -   edit `/etc/makepkg.conf`
    -   modify `OPTIONS=(... debug)` to `OPTIONS=(... !debug)`

-   fix file permissions when copying from ntfs

    ```bash
    find Files/* -type d -exec chmod 755 {} +
    find Files/* -type f -exec chmod 644 {} +
    ```

-   use [quickemu](https://aur.archlinux.org/packages/quickemu) for easy windows or mac vm

    > im currently doing a gpu passthrough which is quite a bit more complicated.<br>
    > find more info here https://wiki.archlinux.org/title/PCI_passthrough_via_OVMF<br>
    > i also highly recommend https://looking-glass.io

    -   `mkdir ~/quickemu && cd ~/quickemu`
    -   `quickget windows 11`
    -   `quickemu --vm windows-11.conf`
    -   install spice tools from attached drive and shutdown vm
    -   download and run [`run-windows.sh`](https://github.com/makidoll/dots/blob/main/other/run-windows.sh)
    -   install software gl+dx support https://github.com/pal1000/mesa-dist-win/releases
        -   in admin run `systemwidedeploy.cmd` and `1. Core desktop OpenGL drivers`
        -   test with [GPU Caps Viewer](https://www.geeks3d.com/dlz/). should be higher than gl 1.0

## Not really using these

-   when using grub2win (try to avoid it i guess)

    ```
    insmod all_video
    set root='(hd0,4)'
    linux /boot/vmlinuz-linux root=/dev/nvme0n1p4 rw
    initrd /boot/initramfs-linux.img
    ```

-   setup alacritty

    [`.config/alacritty/alacritty.yml`](https://raw.githubusercontent.com/makidoll/dots/main/.config/alacritty/alacritty.yml) (haven't really touched this in a while)

-   setup smb for sonos music library

    -   `sudo pacman -S samba`
    -   [`/etc/samba/smb.conf`](https://raw.githubusercontent.com/makidoll/dots/main/etc/samba/smb.conf)
    -   `sudo systemctl enable smb && sudo systemctl start smb`

-   guide to install affinity suite

    https://codeberg.org/wanesty/affinity-wine-docs/src/branch/guide-wine8.14
