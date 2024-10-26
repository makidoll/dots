# Maki's Extras for Arch

-   refresh your mirrorlist

    `sudo reflector --country US --latest 25 --score 25 --sort rate --protocol https --verbose --save /etc/pacman.d/mirrorlist`

-   install yay aur helper

    ```
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
    ```

-   firefox with vertical tabs and more

    -   install mercury browser<br />
        `yay -S mercury-browser-avx2-bin`
    -   install [sideberry](https://addons.mozilla.org/en-US/firefox/addon/sidebery/) extension
    -   css hack [to hide native tabs](<https://github.com/mbnuqw/sidebery/wiki/Firefox-Styles-Snippets-(via-userChrome.css)#completely-hide-native-tabs-strip>)
    -   also add `#sidebar-header { display: none; }`
    -   some custom favicon too [`firefox-favicons.css`](https://github.com/makidoll/dots/blob/main/other/firefox-favicons.css)

    -   install [`minimalist-dracula-darker.xpi`](https://github.com/makidoll/dots/blob/main/other/minimalist-dracula-darker.xpi) theme<br />
        (modified from [MinimalistFox](https://github.com/canbeardig/MinimalistFox))

-   set cpu frequency policy to performance

    -   install cpupower `sudo pacman -S cpupower`
    -   check available governors and current policy `cpupower frequency-info`
    -   modify `/etc/default/cpupower` and set governer to `performance`
    -   enable and start systemd service `sudo systemctl enable --now cpupower`
    -   check if policy was updated `cpupower frequency-info`

    find more info here https://wiki.archlinux.org/title/CPU_frequency_scaling#cpupower

-   TODO: [linux-tkg](https://github.com/Frogging-Family/linux-tkg)

-   improve performance for gaming

    -   https://wiki.archlinux.org/title/Gaming#Increase_vm.max_map_count

        `sudo vim /etc/sysctl.d/80-gamecompatibility.conf`

        ```
        vm.max_map_count = 2147483642
        ```

        `sudo sysctl --system` to apply

    -   https://wiki.archlinux.org/title/Gaming#Tweaking_kernel_parameters_for_response_time_consistency

        `sudo vim /etc/tmpfiles.d/consistent-response-time-for-gaming.conf`

        ```
        #    Path                  Mode UID  GID  Age Argument
        w /proc/sys/vm/compaction_proactiveness - - - - 0
        w /proc/sys/vm/watermark_boost_factor - - - - 1
        w /proc/sys/vm/min_free_kbytes - - - - 1048576
        w /proc/sys/vm/watermark_scale_factor - - - - 500
        w /proc/sys/vm/swappiness - - - - 10
        w /sys/kernel/mm/lru_gen/enabled - - - - 5
        w /proc/sys/vm/zone_reclaim_mode - - - - 0
        w /sys/kernel/mm/transparent_hugepage/enabled - - - - madvise
        w /sys/kernel/mm/transparent_hugepage/shmem_enabled - - - - advise
        w /sys/kernel/mm/transparent_hugepage/defrag - - - - never
        w /proc/sys/vm/page_lock_unfairness - - - - 1
        w /proc/sys/kernel/sched_child_runs_first - - - - 0
        w /proc/sys/kernel/sched_autogroup_enabled - - - - 1
        w /proc/sys/kernel/sched_cfs_bandwidth_slice_us - - - - 3000
        w /sys/kernel/debug/sched/base_slice_ns  - - - - 3000000
        w /sys/kernel/debug/sched/migration_cost_ns - - - - 500000
        w /sys/kernel/debug/sched/nr_migrate - - - - 8
        ```

-   make emojis work by running<br />
    `yay -S noto-fonts-emoji noto-color-emoji-fontconfig`

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
