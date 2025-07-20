#!/bin/bash

set -ouex pipefail

### Remove Packages
dnf remove -y \
    plasma-discover-rpm-ostree \
    toolbox

dnf update -y

#Install RPM Fusion & Codecs
dnf install -y \
  https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm

dnf install -y \
    libheif-freeworld

dnf swap ffmpeg-free ffmpeg --allowerasing -y
dnf swap mesa-va-drivers mesa-va-drivers-freeworld -y
dnf swap mesa-vdpau-drivers mesa-vdpau-drivers-freeworld -y

#Install Firefox PWA Runtime
curl -fsSL https://github.com/filips123/PWAsForFirefox/releases/download/v2.15.0/firefoxpwa-2.15.0-1.x86_64.rpm -o /tmp/firefoxpwa.rpm
dnf --setopt=install_weak_deps=False install -y /tmp/firefoxpwa.rpm

### Install packages

dnf install distrobox ksshaskpass libvirt-daemon-config-network libvirt-daemon-kvm swtpm-selinux qemu-kvm virt-manager -y
dnf install fish borgbackup solaar plasma-firewall-firewalld -y

## Enable automatic update staging.
sed -i 's/#AutomaticUpdatePolicy.*/AutomaticUpdatePolicy=stage/' /etc/rpm-ostreed.conf
systemctl enable rpm-ostreed-automatic.timer
systemctl enable swtpm-workaround
