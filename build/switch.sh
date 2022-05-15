#!/bin/sh

apt-get install git -yq
mkdir -p ~/creation_script/assets && cd ~/creation_script
git clone https://github.com/rollingrhinoremix/distro ~/creation_script/assets
apt-get --allow-releaseinfo-change update -y
apt-get --allow-releaseinfo-change dist-upgrade -y
apt-get autopurge -y
mv ~/creation_script/assets/rolling_rhino.png /usr/share/backgrounds
mv ~/creation_script/assets/rolling_rhino-dark.png /usr/share/backgrounds
mv ~/creation_script/assets/.bashrc /etc/skel
mv ~/creation_script/assets/.bash_aliases /etc/skel
chmod +x ~/creation_script/assets/.sources.sh && bash ~/creation_script/assets/.sources.sh
mv ~/creation_script/assets/.sources.sh /etc/skel
rm -rf /etc/os-release
mv ~/creation_script/assets/os-release /etc
rm -rf /usr/share/glib-2.0/schemas/10_ubuntu-settings.gschema.override
mv ~/creation_script/assets/10_ubuntu-settings.gschema.override /usr/share/glib-2.0/schemas
# Install rhino-config onto system
mkdir ~/creation_script/rhino-config
cd ~/creation_script/rhino-config
wget -nv https://github.com/rollingrhinoremix/rhino-config/releases/download/v2.0.1/rhino-config
chmod +x ~/creation_script/rhino-config/rhino-config
mv ~/creation_script/rhino-config/rhino-config /usr/bin
# Download the mainline Linux kernel packages
mkdir ~/creation_script/kernel
cd ~/creation_script/kernel
wget -q --show-progress --progress=bar:force https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.17.7/amd64/linux-headers-5.17.7-051707-generic_5.17.7-051707.202205121146_amd64.deb
wget -q --show-progress --progress=bar:force https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.17.7/amd64/linux-headers-5.17.7-051707_5.17.7-051707.202205121146_all.deb
wget -q --show-progress --progress=bar:force https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.17.7/amd64/linux-image-unsigned-5.17.7-051707-generic_5.17.7-051707.202205121146_amd64.deb
wget -q --show-progress --progress=bar:force https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.17.7/amd64/linux-modules-5.17.7-051707-generic_5.17.7-051707.202205121146_amd64.deb
# Install the packages via apt
sudo apt install ./*.deb
rm -rf ~/creation_script
cd /
#Install the updated stuff...
apt-get clean -y
apt-get --allow-releaseinfo-change update -y
apt-get --allow-releaseinfo-change dist-upgrade -y
echo '<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE wallpapers SYSTEM "gnome-wp-list.dtd">
<wallpapers>
  <wallpaper>
    <name>Rolling-Rhino</name>
    <name xml:lang="en_GB">Rolling-Rhino</name>
    <filename>/usr/share/backgrounds/rolling_rhino.png</filename>
    <filename-dark>/usr/share/backgrounds/rolling_rhino-dark.png</filename-dark>
    <options>zoom</options>
    <shade_type>solid</shade_type>
  </wallpaper>
</wallpapers>' | tee -a /usr/share/gnome-background-properties/rolling-rhino-wallpapers.xml
apt-get autopurge -y
