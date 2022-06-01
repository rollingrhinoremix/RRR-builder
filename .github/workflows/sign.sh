#!/usr/bin/bash

echo "$KEY" | sudo tee ~/RRR-builder/private.pgp > /dev/null
GPG_TTY=$(tty)
export GPG_TTY
echo "$PASSPHRASE" | sudo gpg --batch --allow-secret-key-import --import ~/RRR-builder/private.pgp
source ~/RRR-builder/build.conf
gpg -o ~/RRR-builder/"$OUT_ISO".sig --batch -ab ~/RRR-builder/"$OUT_ISO"
