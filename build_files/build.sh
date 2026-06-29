#!/bin/bash

set -ouex pipefail

### Remove Packages
dnf remove -y \
    plasma-discover-rpm-ostree \
    toolbox \
    plasma-discover

dnf update -y

### Add VPN Repo
dnf config-manager addrepo --from-repofile=https://repository.mullvad.net/rpm/stable/mullvad.repo

### Setup a way to install this since Fedora atomic mounts the local /var and overwrites anything not layered locally.
rm /opt
ln -s /usr/bin /opt

dnf install -y mullvad-vpn

### Reset the opt link.
rm /opt
ln -s /var/opt /opt


## Add RPM Fusion Repositories and working libheif
dnf install -y \
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm 

dnf install -y libheif-freeworld
dnf swap ffmpeg-free ffmpeg --allowerasing -y
dnf install @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin -y
dnf install mesa-va-drivers-freeworld -y

## Add Darkly Theme
dnf copr enable deltacopy/darkly -y
dnf install -y darkly

## Install Firefox PWA
tee /etc/yum.repos.d/firefoxpwa.repo > /dev/null <<EOF
[firefoxpwa]
name=FirefoxPWA
metadata_expire=7d
baseurl=https://packagecloud.io/filips/FirefoxPWA/rpm_any/rpm_any/\$basearch
gpgkey=https://packagecloud.io/filips/FirefoxPWA/gpgkey
       https://packagecloud.io/filips/FirefoxPWA/gpgkey/filips-FirefoxPWA-912AD9BE47FEB404.pub.gpg
repo_gpgcheck=1
gpgcheck=1
enabled=1
EOF

dnf -q makecache -y --disablerepo="*" --enablerepo="firefoxpwa"
dnf install firefoxpwa -y


### Install packages (Distrobox, Fish, Backup Solution)
dnf install distrobox ksshaskpass fish borgbackup solaar fluidsynth lm_sensors podman-compose -y

### Install Applications
dnf install thunderbird okular gwenview -y

### Packages needed for winapps.
dnf install curl dialog freerdp git iproute libnotify nmap-ncat -y

### Virtualization Support
dnf install -y libvirt qemu-kvm swtpm

## Enable workaround for qemu/kwm swtpm issue
systemctl enable swtpm-workaround
systemctl enable mullvad-daemon
systemctl enable mullvad-early-boot-blocking