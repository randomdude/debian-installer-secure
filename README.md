# debian-installer-secure

debian-installer will accept a preseed URL via the DHCP 'filename' option.
This allows an attacker on your network to provide a malicious preseed URL
which is then silently used by the installer - for example, executing commands
or adding users. I find this a security concen, so I wrote this (very simple)
patch for network-preseed to alter the behaviour of the installer.

The patched installer will prompt the user, if a preseed URL is provided via
DHCP, giving them the option to ignore it or to keep it. This dialog can be
supressed at the kernel commandline - just add

```sh
preseed/accept_preseed_from_DHCP=true
```

to restore the old behaviour of accepting any preseed URL via DHCP.

This has been reported to the debian-installer team, but the team were unwilling
to change behaviour in case it breaks existing installs.
See [debian bug 788632][1] for more information.

To use, run the included script from a debian machine, after installing prereqs:

```sh
apt-get build-dep debian-installer
apt-get install dh_make
```

[1]:https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=788634
