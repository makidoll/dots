# Maki's Extras for Arch

-   refresh your mirrorlist

    `sudo reflector --country US --latest 25 --score 25 --sort rate --protocol https --verbose --save /etc/pacman.d/mirrorlist`

-   install yay aur helper

    ```
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
    ```

-   firefox with vertical tabs

    -   install [sideberry](https://addons.mozilla.org/en-US/firefox/addon/sidebery/) extension
    -   css hack [to hide native tabs](<https://github.com/mbnuqw/sidebery/wiki/Firefox-Styles-Snippets-(via-userChrome.css)#completely-hide-native-tabs-strip>)
    -   also add `#sidebar-header { display: none; }`
    -   install [`minimalist-dracula-darker.xpi`](https://github.com/makidoll/dots/blob/main/other/minimalist-dracula-darker.xpi) theme (modified from [MinimalistFox](https://github.com/canbeardig/MinimalistFox))

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
