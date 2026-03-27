#!/bin/bash

set -ouex pipefail

### Remove Packages
dnf remove -y \
    plasma-discover-rpm-ostree \
    toolbox

dnf update -y

### Install packages (Distrobox, Fish, Backup Solution)
dnf install distrobox ksshaskpass fish borgbackup solaar plasma-firewall-firewalld fluidsynth easyeffects lm_sensors -y

## Enable workaround for qemu/kwm swtpm issue
systemctl enable swtpm-workaround
