#!/bin/sh

# Install build deps
apt-get -y build-dep network-preseed

# Set the DEBIAN_RELEASE and USE_UDEBS_FROM env vars to the current dist codename.
# They are required by the debian-installer build process.
codename=`lsb_release -c | cut -f 2`
export DEBIAN_RELEASE=$codename
export USE_UDEBS_FROM=$codename

# Download the real network-preseed package
apt-get download network-preseed
if [ $? -ne 0 ]; then
	echo "Failed to 'apt-get download network-preseed'."
	echo "Do you have a line simlar to ' deb http://ftp.uk.debian.org/debian jessie main/debian-installer' in your /etc/apt/sources.list? You should."
	exit -1
fi

mv network-preseed*.udeb new.udeb

# Extract the old package
mkdir -p new/DEBIAN
dpkg-deb --fsys-tarfile new.udeb | tar -C new -x
dpkg-deb -e new.udeb new/DEBIAN

# Apply our patch
cat preseed.patch | patch -p 0

# Now build the udeb
dpkg-deb --build new

# Get the debian-installer source
apt-get source debian-installer
cd debian-installer*/build

# copy the newly-build udeb into the localdebs dir
cp ../../new.deb localudebs/network-preseed.deb

# and build the debian-installer.
make reallyclean
fakeroot make build_netboot

