# Maki's Arch Install Guide

> ⚠️ This needs an overhaul

This could get outdated any time, but _i use arch btw_ so I'm sure it'll get updated!

## 1. Core installation

<ul>
<li>
<details>
<summary>UEFI/GPT (w or w/o Windows installed)</summary>
    
-   create a 512 MB parition, type: EFI system **(don't if you already have one)**<br>
    create second parition for the rest<br>
    `cfdisk /dev/nvme0n1`

-   build FAT32 on 512 MB one **(only if you made one)**<br>
    `mkfs.fat -F32 /dev/nvme0n1p1`

-   build ext4 on the other<br>
    `mkfs.ext4 /dev/nvme0n1p2`

-   mount the large ext4 partition<br>
    `mount /dev/nvme0n1p2 /mnt`

-   if you **just made** an EFI partition

    -   create directory and mount<br>
        `mkdir /mnt/boot`<br>
        `mount /dev/nvme0n1p1 /mnt/boot`

-   otherwise, if you **already have** one<br>

    -   create seperate directory and mount<br>
        `mkdir /mnt/efi`<br>
        `mount /dev/nvme0n1p1 /mnt/efi`

</details>
</li>
</ul>

<ul>
<li>
<details>
<summary>BIOS/MBR (legacy)</summary>
    
-   create a single partition and make it bootable<br>
    `cfdisk /dev/nvme0n1`

-   build ext4 filesystem to it<br>
    `mkfs.ext4 /dev/nvme0n1p1`

-   mount the new partition<br>
    `mount /dev/nvme0n1p1 /mnt`

</details>
</li>
</ul>

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

<ul>
<li>
<details>
<summary>UEFI/GPT</summary>
    
-   install amd-ucode or intel-ucode depending on CPU<br>
    `pacman -S amd-ucode`
    
- Pick a bootloader. Find more here: https://wiki.archlinux.org/title/Arch_boot_process#Boot_loader

<ul>
<li>
<details>
<summary>grub (includes os-prober for Windows)</summary>

-   install a packages<br>
    `pacman -S grub efibootmgr os-prober`

-   uncomment GRUB_DISABLE_OS_PROBER=false<br>
    `nano /etc/default/grub`

-   if you **just made** an EFI parition<br>
    `mkdir /boot/EFI`<br>
    `grub-install --target=x86_64-efi --efi-directory=/boot/EFI --bootloader-id=GRUB`<br>
    `grub-mkconfig -o /boot/grub/grub.cfg`

-   if you **already had** an EFI parition<br>
    `grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB`<br>
    `grub-mkconfig -o /boot/grub/grub.cfg` (maybe this needs to be /efi/grub/grub.cfg?)

</details>
</li>
</ul>

<ul>
<li>
<details>
<summary>systemd-boot</summary>

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

</details>
</li>
</ul>

</details>
</li>
</ul>

<ul>
<li>
<details>
<summary>BIOS/MBR (legacy)</summary>
    
-   install and configure grub<br>
    `pacman -S grub os-prober`<br>
    `grub-install --recheck /dev/nvme0n1`<br>
    `grub-mkconfig -o /boot/grub/grub.cfg`

</details>
</li>
</ul>

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

-   uncomment color and parallel downloads, and enable x86 repo in pacman.conf<br>
    `nano /etc/pacman.conf`

    ```
    # Misc options
    Color
    ParallelDownloads = 5

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

    see more here: https://wiki.archlinux.org/title/Xorg#Driver_installation

    | Brand  | Type        | Packages                                                         |
    | ------ | ----------- | ---------------------------------------------------------------- |
    | NVIDIA | Proprietary | `nvidia nvidia-utils lib32-nvidia-utils`                         |
    | AMD    | Open Source | `xf86-video-amdgpu lib32-mesa vulkan-radeon lib32-vulkan-radeon` |

-   install Xorg packages<br>
    `pacman -S xorg-server xorg-xinit`

-   install desktop environment<br>
    `pacman -S gnome gnome-extra gnome-themes-extra`

-   install and enable desktop manager<br>
    `pacman -S gdm`<br>
    `systemctl enable gdm`

-   reboot<br>
    `reboot`

## 4. Extras

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

        -   [Dash to Panel](https://extensions.gnome.org/extension/1160/dash-to-panel/), [Dash to Dock](https://extensions.gnome.org/extension/307/dash-to-dock/) or [Vertical overview](https://extensions.gnome.org/extension/4144/vertical-overview/)
        -   [Tray Icons: Reloaded](https://extensions.gnome.org/extension/2890/tray-icons-reloaded/)

    -   using tweaks, disable **Middle Click Paste** in **Keyboard & Mouse**

-   fix file permissions when copying from ntfs

    ```bash
    find Files/* -type d -exec chmod 755 {} +
    find Files/* -type f -exec chmod 644 {} +
    ```

-   guide to install affinity suite

    https://codeberg.org/wanesty/affinity-wine-docs/src/branch/guide-wine8.14

-   themes

    -   [Papirus Icon Theme](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme#kde-colorscheme)

## 4.5. Extras (not really using)

-   when using grub2win (try to avoid it i guess)

    ```
    insmod all_video
    set root='(hd0,4)'
    linux /boot/vmlinuz-linux root=/dev/nvme0n1p4 rw
    initrd /boot/initramfs-linux.img
    ```

-   setup alacritty

    -   [`.config/alacritty/alacritty.yml`](https://raw.githubusercontent.com/makitsune/dots/main/.config/alacritty/alacritty.yml) (haven't really touched this in a while)

-   setup deadbeef

    -   `yay -S deadbeef deadbeef-gnome-mmkeys-git deadbeef-plugin-fb-gtk3-git deadbeef-plugin-musical-spectrum-gtk3-git deadbeef-plugin-spectrogram-gtk3-git deadbeef-plugin-pipewire-gtk3-git deadbeef-plugin-discord-git`
    -   [`.config/deadbeef/config`](https://raw.githubusercontent.com/makitsune/dots/main/.config/deadbeef/config)

-   setup smb for sonos music library

    -   `sudo pacman -S samba`
    -   [`/etc/samba/smb.conf`](https://raw.githubusercontent.com/makitsune/dots/main/etc/samba/smb.conf)
    -   `sudo systemctl enable smb && sudo systemctl start smb`
