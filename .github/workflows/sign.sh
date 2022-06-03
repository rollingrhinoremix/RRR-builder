#!/usr/bin/bash

echo "$KEY" | sudo tee ~/RRR-builder/private.pgp > /dev/null
GPG_TTY=$(tty)
export GPG_TTY
sudo echo "$PASSPHRASE" | sudo gpg --batch --allow-secret-key-import --import ~/RRR-builder/private.pgp
source ~/RRR-builder/build.conf
echo "$PASSPHRASE" | sudo gpg -o ~/RRR-builder/"$OUT_ISO".sig --with-colons --status-fd 0 --command-fd 0 --no-batch --pinentry-mode loopback -u 945D30DAB6C43922 -ab ~/RRR-builder/"$OUT_ISO"
exit 0
