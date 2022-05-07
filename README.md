##ISO build system for Rolling Rhino Remix
### How to install
you need to have `cd-boot-images-amd64` and `xorriso`
next you can `chmod +x ./fetch_build && ./fetch_build`
to build the entire iso.
to build a different spin of Rolling Rhino Remix, switch branches.

###How to create your own spin
the files you'll need to edit are build.conf, grub.cfg, loopback.cfg, files in `./build`,
and maybe fetch_build.conf
This may look intimidating but don't worry.
for loopback.cfg and grub.cfg all you have to do is edit the names from
`Rolling Rhino` to whatever the name of os is. Currently this will be automated in future
the `fetch_build.conf` is where the base iso is from and generally it uses ubiquity,
and is apt-based but doesn't have to be and generally it can be untouched most of time.
Next `build.conf` I think this is self explaintory but this is name of os, disk info
and the name if outputting .iso.
next the files in `./build`, the `build.sh` is used for startup generally this is used
in the middle to remove gnome packages and stuff but it is okay if you do it in the
`switch.sh` which converts your install to the os you see it as.

###Suggestions
If you want to create a unnoficial spin,
you can create a pr and create a new branch for the spin.
If you don't know how but have suggestions create a issue
but know that most ideas I'd probably not want to do and maintain and thus close issue.
