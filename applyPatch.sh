# Download the real network-preseed package
apt-get download network-preseed
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

