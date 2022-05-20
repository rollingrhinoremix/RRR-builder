.PHONY: enter iso test

SHELL=/bin/bash

all: iso

enter: .edit.timestamp
	cp /etc/resolv.conf edit/etc/
	- cp edit/etc/hosts .hosts.backup || true
	cp /etc/hosts edit/etc/
	cp -r build edit/
	cp extract-cd/casper/initrd edit/boot/initrd.fromiso
	cp extract-cd/casper/vmlinuz edit/boot/vmlinuz.fromiso
	mount -o bind /run/ edit/run
	mount -o bind /dev/ edit/dev
	chmod +x ./build/build.sh ./build/switch.sh
	chroot edit /build/build.sh
	umount edit/dev/pts || true
	umount edit/dev || true
	umount edit/run || true
	rm edit/etc/hosts
	- mv .hosts.backup edit/etc/hosts || true
	cp edit/boot/vmlinuz extract-cd/casper/vmlinuz
	cp edit/boot/initrd.img extract-cd/casper/initrd
	rm -rf edit/build/
	rm -rf edit/root/.bash_history
	rm -rf edit/root/.cache
	touch .enter.timestamp

.edit.timestamp:
	mkdir -p mnt
	mount -o loop ubuntu.iso mnt
	unsquashfs mnt/casper/filesystem.squashfs
	mv squashfs-root edit
	cp -r mnt/ extract-cd/ && rm -f extract-cd/casper/filesystem.squashfs extract-cd/casper/filesystem.squashfs.gpg
	umount mnt
	rmdir mnt
	touch .edit.timestamp

.enter.timestamp: enter
	touch .enter.timestamp

extract-cd/casper: .edit.timestamp .enter.timestamp
	chmod +w extract-cd/casper/filesystem.manifest
	chroot edit dpkg-query -W --showformat='$${Package} $${Version}\n' > extract-cd/casper/filesystem.manifest
	sed -ri 's/\s+//g' extract-cd/casper/filesystem.manifest-minimal-remove
	echo "$(cat minimal-option)" >> extract-cd/casper/filesystem.manifest-minimal-remove
	printf "$(awk '!seen[$0]++' extract-cd/casper/filesystem.manifest-minimal-remove)" > extract-cd/casper/filesystem.manifest-minimal-remove
	sed -i '${s/$/  /}' extract-cd/casper/filesystem.manifest-minimal-remove

extract-cd/casper/filesystem.squashfs: extract-cd/casper
	- rm extract-cd/casper/filesystem.squashfs
	mksquashfs edit extract-cd/casper/filesystem.squashfs -b 1048576 -comp xz -always-use-fragments

extract-cd/casper/filesystem.size: extract-cd/casper/filesystem.squashfs
	printf $$(sudo du -sx --block-size=1 edit | cut -f1) > extract-cd/casper/filesystem.size

extract-cd/README.diskdefines:
	source build.conf && echo '#define DISKNAME  '"$$DISKNAME" > extract-cd/README.diskdefines
	echo '#define TYPE  binary' >> extract-cd/README.diskdefines
	echo '#define TYPEbinary  1' >> extract-cd/README.diskdefines
	echo '#define ARCH  amd64' >> extract-cd/README.diskdefines
	echo '#define ARCHamd64  1' >> extract-cd/README.diskdefines
	echo '#define DISKNUM  1' >> extract-cd/README.diskdefines
	echo '#define DISKNUM1  1' >> extract-cd/README.diskdefines
	echo '#define TOTALNUM  0' >> extract-cd/README.diskdefines
	echo '#define TOTALNUM0  1' >> extract-cd/README.diskdefines

extract-cd/.disk: .edit.timestamp .enter.timestamp
	source build.conf && echo "$$DISKNAME" > extract-cd/.disk/info
	source build.conf && echo "$$RELEASE_URL" > extract-cd/.disk/release_notes_url

extract-cd/boot: .edit.timestamp .enter.timestamp
	cp grub.cfg extract-cd/boot/grub/grub.cfg
	cp loopback.cfg extract-cd/boot/grub/loopback.cfg

extract-cd/md5sum.txt: extract-cd/casper/filesystem.squashfs extract-cd/casper/filesystem.size
	cd extract-cd; rm md5sum.txt; find -type f -print0 | sudo xargs -0 md5sum | /usr/bin/env grep -v 'md5sum.txt' | /usr/bin/env grep -v 'boot.catalog' | /usr/bin/env grep -v 'eltorito.img' > md5sum.txt

build.iso: extract-cd/.disk extract-cd/boot extract-cd/README.diskdefines extract-cd/md5sum.txt
	source build.conf && rm -f "$$OUT_ISO" && cd extract-cd && xorriso -as mkisofs -r -checksum_algorithm_iso md5,sha1 -J -joliet-long -l \
		-b boot/grub/i386-pc/eltorito.img -no-emul-boot -boot-load-size 4 -boot-info-table --grub2-boot-info \
		--grub2-mbr /usr/share/cd-boot-images-amd64/images/boot/grub/i386-pc/boot_hybrid.img \
		-append_partition 2 0xef /usr/share/cd-boot-images-amd64/images/boot/grub/efi.img \
		-appended_part_as_gpt -eltorito-alt-boot -e --interval\:appended_partition_2\:all\:\: -no-emul-boot \
		-partition_offset 16 /usr/share/cd-boot-images-amd64/tree \
		-V "$$DISKNAME" -o "../$$OUT_ISO" .
	source build.conf && rm -f "$$OUT_ISO.md5sum" && md5sum "$$OUT_ISO" > "$$OUT_ISO.md5sum"

iso: build.iso

build.iso-zstd: build.iso
	source build.conf && zstd -16 "$$OUT_ISO"

clean:
	umount edit/dev/pts || true
	umount edit/dev || true
	umount edit/run || true
	umount mnt || true
	@rm -rf edit extract-cd mnt squashfs-root .edit.timestamp .enter.timestamp .hosts.backup

clean-iso: clean
	source build.conf && rm -f "$$OUT_ISO" "$$OUT_ISO.md5sum"
