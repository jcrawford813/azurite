if test "$(id -u)" -gt "0" && test -d "$HOME"; then
    if test ! -e "$HOME"/.config/azurite/firstboot-done; then
        mkdir -p "$HOME"/.config/autostart
        cp -f /etc/skel.d/.config/autostart/azurite-first-setup.desktop "$HOME"/.config/autostart
    fi
fi