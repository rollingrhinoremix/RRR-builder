#!/bin/sh

# Update repos
apt-get update -y
# Initialise the development by grabbing assets
apt-get install git xdg-user-dirs -yq # These are mostly already installed. Just setting it to manually installed for minimal
# Perform system upgrade
apt-get update -y
apt-get upgrade -y
apt autopurge -y
# Create creation dir
mkdir -p ~/creation/ && cd ~/creation
# Install items within the dir
wget -q https://github.com/pacstall/pacstall/releases/download/2.0.1/pacstall-2.0.1.deb
apt install ./pacstall-2.0.1.deb -y
wget -q https://github.com/rollingrhinoremix/rhino-deinst/releases/latest/download/rhino-deinst
chmod +x ~/creation/rhino-deinst
mv ~/creation/rhino-deinst /usr/bin
# Configure Pacstall
pacstall -PA https://raw.githubusercontent.com/rollingrhinoremix/repo/master
# Install pacstall apps
pacstall -PI linux-kernel
pacstall -PI xfce4-deb
# Clean up system files
apt-get clean -y
sed -i 's/kinetic/devel/g' /etc/apt/sources.list
sed -i 's/kinetic/devel/g' /etc/lsb-release
sed -i 's/kinetic/devel/g' /usr/lib/os-release
# So much release info that are mostly same!
sed -i 's/PRETTY_NAME="Ubuntu Kinetic Kudu (development branch)"/PRETTY_NAME="Rolling Rhino Linux"/g' /etc/os-release
sed -i 's%HOME_URL="https://www.ubuntu.com/"%HOME_URL="https://rollingrhino.org"%g' /etc/os-release
apt-get --allow-releaseinfo-change update -y
apt-get --allow-releaseinfo-change dist-upgrade -y
apt-get autopurge -y
apt-get clean
sed -i 's/^set -e//g' /var/lib/dpkg/info/snapd.prerm # For minimal as snapd fails at some point
sed -i 's/^set -e//g' /var/lib/dpkg/info/snapd.postrm
echo 'find / -type f -name "*snap*" -delete 2> /dev/null' >> /var/lib/dpkg/info/snapd.postrm # To make snap is fully removed
echo 'rm -rf /snap' >> /var/lib/dpkg/info/snapd.postrm
echo 'rm -rf ~/snap' >> /var/lib/dpkg/info/snapd.postrm
echo 'rm -rf /root/snap' >> /var/lib/dpkg/info/snapd.postrm
rm -rf ~/creation