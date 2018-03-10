from debian:jessie

run echo deb http://ftp.uk.debian.org/debian jessie main/debian-installer >> /etc/apt/sources.list
run echo deb-src http://ftp.uk.debian.org/debian jessie main contrib non-free >> /etc/apt/sources.list
run apt-get update -y
run apt-get upgrade -y

# Build deps we need
run apt-get -y build-dep network-preseed debian-installer
# Runtimes our build script needs
run apt-get -y install lsb-release fakeroot apt-utils

copy applyPatch.sh /root/
copy preseed.patch /root/

entrypoint  /root/applyPatch.sh

