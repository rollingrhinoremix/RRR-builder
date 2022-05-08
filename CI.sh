#!/usr/bin/bash
#This is for CI as some very hacky methods have to be used because of github action to save space.
sudo apt-get update -y
sudo apt-get dist-upgrade
sudo apt-get install axel xorriso coreutils squashfs-tools -y
wget "http://mirrors.kernel.org/ubuntu/pool/main/c/cd-boot-images-amd64/cd-boot-images-amd64_17_all.deb"
sudo dpkg -i "cd-boot-images-amd64_17_all.deb"
rm -rf "./cd-boot-images-amd64_17_all.deb"
source fetch_build.conf && axel "DOWNLOAD_ISO" --output="ubuntu.iso"
chmod +x ./build/build.sh ./build/switch.sh
sudo df -h
sudo make build.iso
rm -rf ./ubuntu.iso
