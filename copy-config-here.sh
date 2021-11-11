rm -rf .config

# home
mkdir -p .config/alacritty/
cp -r ~/.config/alacritty/alacritty.yml .config/alacritty/

mkdir -p .config/deadbeef/
cp -r ~/.config/deadbeef/config .config/deadbeef/

# root
mkdir -p etc/samba/
cp -r /etc/samba/smb.conf etc/samba/