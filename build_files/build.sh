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


### Install packages (Distrobox, Fish, Virtualization, Backup Solution)

dnf install distrobox ksshaskpass libvirt-daemon-config-network libvirt-daemon-kvm swtpm-selinux qemu-kvm virt-manager lm_sensors -y
dnf install fish borgbackup solaar plasma-firewall-firewalld fluidsynth thunderbird easyeffects -y

### Install kde packages
dnf install skanpage tesseract gwenview okular neochat krita digikam haruna kcalc -y

## Enable workaround for qemu/kwm swtpm issue
systemctl enable swtpm-workaround
