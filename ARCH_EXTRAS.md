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

    -   assign **Switch Windows** keyboard shortcut to alt+tab

    -   using tweaks, disable **Middle Click Paste** in **Keyboard & Mouse**

    -   incase `file://` uris dont open in gnome nautilus

        `xdg-mime default org.gnome.Nautilus.desktop inode/directory`

    -   extensions

        -   [AppIndicator and KStatusNotifierItem Support](https://extensions.gnome.org/extension/615/appindicator-support/) adds tray icons back
        -   [Freon](https://extensions.gnome.org/extension/841/freon/) shows cpu temp and more
        -   [GameMode](https://extensions.gnome.org/extension/1852/gamemode/) shows indicator when `gamemoderun`

        -   [Hide Top Bar](https://extensions.gnome.org/extension/545/hide-top-bar/) gives back space
        -   [Rounded Window Corners](https://extensions.gnome.org/extension/5237/rounded-window-corners/) is just nice

        recommended to install above using yay (cause devs arent updating their extensions on gnome.org)

        `yay -S --noconfirm gnome-shell-extension-appindicator-git gnome-shell-extension-freon-git gnome-shell-extension-gamemode-git gnome-shell-extension-rounded-window-corners-git gnome-shell-extension-hidetopbar-git`

        honorable but not using

        -   [Dash to Panel](https://extensions.gnome.org/extension/1160/dash-to-panel/)
        -   [Dash to Dock](https://extensions.gnome.org/extension/307/dash-to-dock/)
        -   [Vertical overview](https://extensions.gnome.org/extension/4144/vertical-overview/)
        -   [Grand Theft Focus](https://extensions.gnome.org/extension/5410/grand-theft-focus/) brings ready windows into focus

-   fix file permissions when copying from ntfs

    ```bash
    find Files/* -type d -exec chmod 755 {} +
    find Files/* -type f -exec chmod 644 {} +
    ```

-   themes

    -   [Papirus Icon Theme](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme#kde-colorscheme)

-   setup deadbeef

    -   `yay -S deadbeef-git deadbeef-mpris2-plugin deadbeef-plugin-fb-gtk3-git deadbeef-plugin-spectrogram-gtk3-git deadbeef-plugin-discord-git`
    -   [`.config/deadbeef/config`](https://raw.githubusercontent.com/makitsune/dots/main/.config/deadbeef/config)

-   force microphone to fixed volume using wireplumber ctl and systemd

    -   `vim ~/.config/systemd/user/yeti-nano-fixed-volume.service`

        ```
        [Unit]
        Description=Yeti Nano Fixed Volume

        [Service]
        ExecStart=bash -c 'while sleep 0.1; do wpctl set-volume $(wpctl status | grep -Eio "[0-9]+. Yeti Nano Analog Stereo" | grep -Eio "[0-9]+") 60%; done'
        Type=simple
        # treat as a lowest priority program
        Nice=19

        [Install]
        WantedBy=default.target
        ```

    -   `systemctl enable --now --user yeti-nano-fixed-volume.service`
    -   `systemctl status --user yeti-nano-fixed-volume.service` make sure its not erroring

-   firefox with vertical tabs

    -   install [sideberry](https://addons.mozilla.org/en-US/firefox/addon/sidebery/) extension
    -   css hack [to hide native tabs](<https://github.com/mbnuqw/sidebery/wiki/Firefox-Styles-Snippets-(via-userChrome.css)#completely-hide-native-tabs-strip>)
    -   also add `#sidebar-header { display: none; }`
    -   install [`minimalist-dracula-darker.xpi`](https://github.com/makidoll/dots/blob/main/other/minimalist-dracula-darker.xpi) theme (modified from [MinimalistFox](https://github.com/canbeardig/MinimalistFox))

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

    [`.config/alacritty/alacritty.yml`](https://raw.githubusercontent.com/makitsune/dots/main/.config/alacritty/alacritty.yml) (haven't really touched this in a while)

-   setup smb for sonos music library

    -   `sudo pacman -S samba`
    -   [`/etc/samba/smb.conf`](https://raw.githubusercontent.com/makitsune/dots/main/etc/samba/smb.conf)
    -   `sudo systemctl enable smb && sudo systemctl start smb`

-   guide to install affinity suite

    https://codeberg.org/wanesty/affinity-wine-docs/src/branch/guide-wine8.14
