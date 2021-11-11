# Maki's Arch Install Guide

This could get outdated any time, but _i use arch btw_ so I'm sure it'll get updated!

## 1. Core installation

-   BIOS/MBR

    -   create a single partition and make it bootable<br>
        `cfdisk /dev/nvme0n1`

    -   build ext4 filesystem to it<br>
        `mkfs.ext4 /dev/nvme0n1p1`

    -   mount the new partition<br>
        `mount /dev/nvme0n1p1 /mnt`

-   UEFI/GPT

    -   create a 512 MB parition, type: EFI system
        create second parition for the rest<br>
        `cfdisk /dev/nvme0n1`

    -   build FAT32 on 512 MB one<br>
        `mkfs.fat -F32 /dev/nvme0n1p1`

    -   build ext4 on the other<br>
        `mkfs.ext4 /dev/nvme0n1p2`

    -   mount the large ext4 partition<br>
        `mount /dev/nvme0n1p2 /mnt`

    -   create directory boot on it<br>
        `mkdir /mnt/boot`

    -   mount 512 MB one into boot<br>
        `mount /dev/nvme0n1p1 /mnt/boot`

-   (optional) set geographicly close mirror top<br>
    `nano /etc/pacman.d/mirrorlist`

-   install the base system<br>
    `pacstrap /mnt base base-devel linux linux-firmware dhcpcd nano`

-   generate fstab<br>
    `genfstab -U /mnt > /mnt/etc/fstab`

-   chroot into the new system<br>
    `arch-chroot /mnt`

-   set password for root<br>
    `passwd`

-   BIOS/MBR

    -   install and configure grub<br>
        `pacman -S grub os-prober`<br>
        `grub-install --recheck /dev/nvme0n1`<br>
        `grub-mkconfig -o /boot/grub/grub.cfg`

-   UEFI/GPT

    -   install amd-ucode or intel-ucode<br>
        `pacman -S amd-ucode`

    -   install systemd bootloader<br>
        `bootctl install`
    -   create new boot entry<br>
        `nano /boot/loader/entries/arch.conf`

        ```
        title		Arch Linux
        linux		/vmlinuz-linux
        initrd		/amd-ucode.img
        initrd		/initramfs-linux.img
        options		root=/dev/nvme0n1p2 rw
        ```

    -   set the default entry<br>
        `nano /boot/loader/loader.conf`

        ```
        timeout 3
        default arch
        ```

-   remove the bootable media, restart PC<br>
    `exit`<br>
    `reboot`

## 2. Basic settings

-   login as root

-   set hostname<br>
    `echo maki > /etc/hostname`

-   add new user and set password<br>
    `useradd -m -G wheel maki`<br>
    `passwd maki`

-   edit sudoers to allow new user to sudo<br>
    `EDITOR=nano visudo`

    ```
    ## Uncomment to allow members of group wheel to execute any command
    %wheel ALL=(ALL) ALL
    ```

-   check the name of your network interface<br>
    `ip link`

-   start aquiring dynamic IP<br>
    `systemctl start dhcpcd@enp60s0`<br>
    `systemctl enable dhcpcd@enp60s0`

-   uncomment desired locales in locale.gen<br>
    `nano /etc/locale.gen`

-   generate new locales and set one system wide<br>
    `locale-gen`<br>
    `localectl set-locale LANG=en_US.UTF-8`

-   select timezone and set it permanent<br>
    `tzselect`<br>
    `timedatectl set-timezone 'America/Los_Angeles'`

-   set hardware clock and sync using ntp<br>
    `hwclock --systohc --utc`<br>
    `timedatectl set-ntp true`

-   setup a swap file if RAM < 2 GB<br>
    `dd if=/dev/zero of=/swapfile count=2048 bs=1MiB`<br>
    `chmod 600 /swapfile`<br>
    `mkswap /swapfile`<br>
    `swapon /swapfile`<br>
    `nano /etc/fstab`

    ```
    /swapfile none swap defaults 0 0
    ```

    `nano /etc/sysctl.d/99-sysctl.conf`

    ```
    vm.swappiness=10
    ```

-   enable color and x86 repo in pacman.conf<br>
    `nano /etc/pacman.conf`

    ```
    # Misc options
    Color

    [multilib]
    Include = /etc/pacman.d/mirrorlist
    ```

-   syncronize repositories and reboot<br>
    `pacman -Sy && reboot`

## 3. Desktop environment

-   login as regular user
-   install the default video driver<br>
    `pacman -S xf86-video-vesa`

-   install OpenGL support<br>
    `pacman -S mesa`

-   install video driver specific for your hardware

    open source:

    | Brand  | Driver               |
    | ------ | -------------------- |
    | AMD    | `xf86-video-amdgpu`  |
    |        | `xf86-video-ati`     |
    | Intel  | `xf86-video-intel`   |
    | Nvidia | `xf86-video-nouveau` |

    proprietary:

    | Brand  | Driver           |
    | ------ | ---------------- |
    | AMD    | `catalyst` (aur) |
    | Nvidia | `nvidia`         |
    |        | `nvidia-340xx`   |
    |        | `nvidia-304xx`   |

-   install Xorg packages<br>
    `pacman -S xorg-server xorg-xinit xterm`

-   install desktop environment<br>
    `pacman -S gnome gnome-extra`

-   install and enable desktop manager<br>
    `pacman -S gdm`<br>
    `systemctl enable gdm`

-   reboot<br>
    `reboot`

## 4. Extras

-   when using grub2win

    ```
    insmod all_video
    set root='(hd0,4)'
    linux /boot/vmlinuz-linux root=/dev/nvme0n1p4 rw
    initrd /boot/initramfs-linux.img
    ```

-   refresh your mirrorlist

    `sudo reflector --verbose --latest 20 --protocol https --sort rate --save /etc/pacman.d/mirrorlist`

-   install yay aur helper

    ```
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
    ```

-   gnome recommendations

    -   assign **Switch Windows** keyboard shortcut to alt+tab

    -   extensions
        -   [Vertical overview](https://extensions.gnome.org/extension/4144/vertical-overview/)
        -   [Tray Icons: Reloaded](https://extensions.gnome.org/extension/2890/tray-icons-reloaded/)

-   setup alacritty

    -   [`.config/alacritty/alacritty.yml`](https://raw.githubusercontent.com/makitsune/dots/main/.config/alacritty/alacritty.yml)

-   setup deadbeef

    -   `yay -S deadbeef deadbeef-gnome-mmkeys-git deadbeef-plugin-fb-gtk3-git deadbeef-plugin-musical-spectrum-gtk3-git deadbeef-plugin-spectrogram-gtk3-git deadbeef-plugin-pipewire-gtk3-git`
    -   [`.config/deadbeef/config`](https://raw.githubusercontent.com/makitsune/dots/main/.config/deadbeef/config)

-   setup smb for sonos music library

    -   `sudo pacman -S samba`
    -   [`/etc/samba/smb.conf`](https://raw.githubusercontent.com/makitsune/dots/main/etc/samba/smb.conf)
    -   `sudo systemctl enable smb && sudo systemctl start smb`
