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
rpm --import https://packagecloud.io/filips/FirefoxPWA/gpgkey
echo -e "[firefoxpwa]\nname=FirefoxPWA\nmetadata_expire=7d\nbaseurl=https://packagecloud.io/filips/FirefoxPWA/rpm_any/rpm_any/\$basearch\ngpgkey=https://packagecloud.io/filips/FirefoxPWA/gpgkey\nrepo_gpgcheck=1\ngpgcheck=0\nenabled=1" |  tee /etc/yum.repos.d/firefoxpwa.repo
dnf -q makecache -y --disablerepo="*" --enablerepo="firefoxpwa"
dnf install firefoxpwa -y

### Install packages (Distrobox, Fish, Backup Solution)
dnf install distrobox ksshaskpass fish borgbackup solaar plasma-firewall-firewalld fluidsynth easyeffects lm_sensors thunderbird -y

## Enable workaround for qemu/kwm swtpm issue
systemctl enable swtpm-workaround
