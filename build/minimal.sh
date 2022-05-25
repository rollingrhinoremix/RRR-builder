#!/bin/sh
sed -ri 's/\s+//g' ./extract-cd/casper/filesystem.manifest-minimal-remove
echo "$(cat ./minimal-option)" >> ./extract-cd/casper/filesystem.manifest-minimal-remove
printf "$(awk '!seen[$0]++' ./extract-cd/casper/filesystem.manifest-minimal-remove)" > ./extract-cd/casper/filesystem.manifest-minimal-remove
sed -i '${s/$/  /}' ./extract-cd/casper/filesystem.manifest-minimal-remove
exit 0