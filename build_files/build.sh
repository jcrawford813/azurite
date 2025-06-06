#!/bin/bash

set -ouex pipefail

### Remove Packages
dnf remove -y \
    firefox \
    firefox-langpacks \
    plasma-discover-rpm-ostree \
    toolbox

### Install packages

dnf install distrobox ksshaskpass libvirt-daemon-config-network libvirt-daemon-kvm swtpm-selinux qemu-kvm virt-manager -y
dnf install fish borgbackup solaar plasma-firewall-firewalld -y

## Enable automatic update staging.
sed -i 's/#AutomaticUpdatePolicy.*/AutomaticUpdatePolicy=stage/' /etc/rpm-ostreed.conf
systemctl enable rpm-ostreed-automatic.timer
systemctl enable swtpm-workaround
