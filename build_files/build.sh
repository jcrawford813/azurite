#!/bin/bash

set -ouex pipefail

### Remove Packages
dnf remove -y \
    plasma-discover-rpm-ostree \
    toolbox

dnf update -y

#Install Firefox PWA Runtime
rpm --import https://packagecloud.io/filips/FirefoxPWA/gpgkey
echo -e "[firefoxpwa]\nname=FirefoxPWA\nmetadata_expire=7d\nbaseurl=https://packagecloud.io/filips/FirefoxPWA/rpm_any/rpm_any/\$basearch\ngpgkey=https://packagecloud.io/filips/FirefoxPWA/gpgkey\nrepo_gpgcheck=1\ngpgcheck=0\nenabled=1" |  tee /etc/yum.repos.d/firefoxpwa.repo
dnf -q makecache -y --disablerepo="*" --enablerepo="firefoxpwa"
dnf install firefoxpwa -y

### Install packages (Distrobox, Fish, Backup Solution)
dnf install distrobox ksshaskpass fish borgbackup solaar plasma-firewall-firewalld fluidsynth easyeffects lm_sensors -y

## Enable workaround for qemu/kwm swtpm issue
systemctl enable swtpm-workaround
