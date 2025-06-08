#!/bin/bash

set -ouex pipefail

### Remove Packages
dnf remove -y \
    firefox \
    firefox-langpacks \
    plasma-discover-rpm-ostree \
    toolbox

dnf update -y

#Install Firefox PWA Runtime
curl -fsSL https://github.com/filips123/PWAsForFirefox/releases/download/v2.14.1/firefoxpwa-2.14.1-1.x86_64.rpm -o /tmp/firefoxpwa.rpm
dnf --setopt=install_weak_deps=False install -y /tmp/firefoxpwa.rpm

#Install kernel that doesn't flicker on AMD GPUs.
dnf install -y \
    /ctx/kernel/kernel-6.14.6-300.fc42.x86_64.rpm \
    /ctx/kernel/kernel-core-6.14.6-300.fc42.x86_64.rpm \
    /ctx/kernel/kernel-modules-6.14.6-300.fc42.x86_64.rpm \
    /ctx/kernel/kernel-modules-core-6.14.6-300.fc42.x86_64.rpm \
    /ctx/kernel/kernel-modules-extra-6.14.6-300.fc42.x86_64.rpm

### Install packages

dnf install distrobox ksshaskpass libvirt-daemon-config-network libvirt-daemon-kvm swtpm-selinux qemu-kvm virt-manager -y
dnf install fish borgbackup solaar plasma-firewall-firewalld -y

## Enable automatic update staging.
sed -i 's/#AutomaticUpdatePolicy.*/AutomaticUpdatePolicy=stage/' /etc/rpm-ostreed.conf
systemctl enable rpm-ostreed-automatic.timer
systemctl enable swtpm-workaround
