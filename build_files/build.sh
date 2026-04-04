#!/bin/bash

set -ouex pipefail

### Remove Packages
dnf remove -y \
    plasma-discover-rpm-ostree \
    toolbox

dnf remove -y \
    firefox \
    firefox-langpacks

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

### Install packages (Distrobox, Fish, Backup Solution)
dnf install distrobox ksshaskpass fish borgbackup solaar fluidsynth lm_sensors -y

dnf install -y libvirt qemu-kvm swtpm

## Enable workaround for qemu/kwm swtpm issue
systemctl enable swtpm-workaround
systemctl enable mullvad-daemon
systemctl enable mullvad-early-boot-blocking