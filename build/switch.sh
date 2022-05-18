#!/bin/sh

# Initialise the development by grabbing assets
apt-get install git -yq
mkdir -p ~/creation/assets && cd ~/creation || exit
git clone https://github.com/rollingrhinoremix/assets-desktop ~/creation/assets
# Perform system upgrade
apt-get update -y
apt-get upgrade -y
apt autoremove -y
# Move all required assets to the correct directories
mv ~/creation/assets/rolling_rhino.png /usr/share/backgrounds
mv ~/creation/assets/rolling_rhino-dark.png /usr/share/backgrounds
mv ~/creation/assets/.bashrc /etc/skel
mv ~/creation/assets/.sources.sh /etc/skel
rm -rf /etc/os-release
mv ~/creation/assets/os-release /etc
rm -rf /usr/share/glib-2.0/schemas/10_ubuntu-settings.gschema.override
mv ~/creation/assets/10_ubuntu-settings.gschema.override /usr/share/glib-2.0/schemas
# Install rhino-config onto system 
mkdir ~/creation/rhino-config
cd ~/creation/rhino-config
wget https://github.com/rollingrhinoremix/rhino-config/releases/download/v2.0.1/rhino-config
chmod +x ~/creation/rhino-config/rhino-config
mv ~/creation/rhino-config/rhino-config /usr/bin
# Install rhino-deinst onto system
mkdir ~/creation/rhino-deinst
cd ~/creation/rhino-deinst
wget https://raw.githubusercontent.com/rollingrhinoremix/rhino-deinst/master/rhino-deinst
chmod +x ~/creation/rhino-deinst/rhino-deinst
mv ~/creation/rhino-deinst/rhino-deinst /usr/bin
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
