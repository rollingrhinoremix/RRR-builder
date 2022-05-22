## Official ISO build system for Rolling Rhino Remix
### How to install
First you need 
- `cd-boot-images-amd64`
- `xorriso`
- `axel` (optional, for faster downloads)
- GNU Coreutils

Next `chmod +x ./fetch_build && ./fetch_build` to build the entire iso.
After do `sudo make clean` to clean empty files.


### In detail
First `fetch_build` downloads a file from `fetch_build.conf` and names it `ubuntu.iso` which
is the base for all operations. Next it runs `sudo make`. This defaults to building the ISO.
Next the stuff from [makefile](https://github.com/rollingrhinoremix/RRR-builder/blob/master/Makefile) begins 
where it firsts starts by uncompressing the iso/cd image 
(ubuntu.iso from fetch_build and fetch_build.conf) to `extract-cd` then 
uncompresses the actual stuff you install inside of it to `./edit`.
Then it prepares to go inside of that with chroot and executes
`./build/build.sh` inside the chroot/filesystem which prepares a bit
then executes `./build/switch.sh` which changes the actual OS from generic Ubuntu.
After `switch.sh` is finished `build.sh` ends soon after and the `makefile` still
goes on. Next we move on to editing the cd image; not the filesystem stuff
where the `grub.cfg` and `loopback.cfg` is copied to `extract-cd` and the
filesystem is compressed to save space. Next after the disk stuff has been
defined, it is given md5 checksum to every file inside. And finally with that it is
compressed to a iso with setttings from `build.conf`. and last thing is a md5 of it.


### How to create your own spin
the files you'll need to edit are build.conf, grub.cfg, loopback.cfg, files in `./build`,
./.github/make_release.yml and maybe fetch_build.conf.
This may look intimidating but don't worry.
for loopback.cfg and grub.cfg all you have to do is edit the names from
`Rolling Rhino` to whatever the name of os is. Currently this will be automated in future
the `fetch_build.conf` is where the base iso is from and generally it uses ubiquity,
and is apt-based but doesn't have to be and generally it can be untouched most of time.
Next `build.conf` I think this is self explaintory but this is name of os, disk info
and the name of the outputting .iso.
next the files in `./build`, the `build.sh` is used for startup generally this is used
in the middle to remove gnome packages and stuff but it is okay if you do it in the
`switch.sh` which converts your install to the os. For `.github/make_release.yml` this
is if you want to use github runners but if not then this file isn't needed. Change 
the branch your cloning and at the end for uploading artifacts section you may want to
change the name from rolling-rhino-generic.


### Suggestions
If you want to create a unnoficial spin, you can easily fork this repo and create your
own remix of Rolling Rhino Remix

## Thanks To...
* the original iso builder for Ubuntu Unity: https://gitlab.com/ubuntu-unity/ubuntu-remixes/ubuntu-unity for base project
* original creation_script at https://github.com/rollingrhinoremix/creation_script which helped convert ubuntu to RRR
