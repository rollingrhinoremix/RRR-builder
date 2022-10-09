#!/bin/sh
sed -ri 's/\s+//g' ./extract-cd/casper/filesystem.manifest-minimal-remove
echo "$(cat ./minimal-option)" >> ./extract-cd/casper/filesystem.manifest-minimal-remove
printf "$(awk '!seen[$0]++' ./extract-cd/casper/filesystem.manifest-minimal-remove)" > ./extract-cd/casper/filesystem.manifest-minimal-remove
sed -i '${s/$/  /}' ./extract-cd/casper/filesystem.manifest-minimal-remove
echo -e '\ngnome-characters gnome-control-center
gnome-control-center-data
gnome-control-center-faces
gnome-desktop3-data
gnome-font-viewer
gnome-getting-started-docs
gnome-initial-setup
gnome-keyring gnome-keyring-pkcs11
gnome-logs
gnome-mahjongg
gnome-menus
gnome-mines
gnome-online-accounts
gnome-power-manager
gnome-screenshot
gnome-session-bin
gnome-session-canberra
gnome-session-common
gnome-settings-daemon
gnome-settings-daemon-common
gnome-shell
gnome-shell-common
gnome-shell-extension-appindicator
gnome-shell-extension-desktop-icons
gnome-shell-extension-ubuntu-dock
gnome-startup-applications
gnome-sudoku
gnome-system-monitor
gnome-terminal
gnome-terminal-data
gnome-themes-extra
gnome-themes-extra-data
gnome-todo
gnome-todo-common
gnome-user-docs
gnome-video-effects
ubuntu-desktop-minimal' >> ./extract-cd/casper/filesystem.manifest-remove
exit 0
