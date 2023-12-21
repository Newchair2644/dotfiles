#!/bin/sh
# Install script for my entire system
# Config backups are made automatically in the same dir

DOTFILES_ROOT="${HOME}/.dotfiles"
HOME_BACKUP="${HOME}/home.bak"

# Generic yes/no prompt
prompt() {
    printf "\r%s [\033[0;33my/N\033[0m] " "$1"
    read -r input
    case $input in
        [Yy]*) return 0 ;;
        [Nn]*) return 1 ;;
    esac
}

# Add "tags" to output based on $1
tag() {
    status=$1
    shift
    case $status in
        0)
            msg="OK"
            color="\033[32m" # green
            ;;
        *)
            msg="ERROR"
            color="\033[31m" # red
            ;;
        esac
    while read -r line; do
        printf "${color}[%s]\033[0m: %s\n" "$msg" "$line"
    done
}

# Initial setup (create dirs, backup if needed)
setup() {
    echo "Backing ~/ to ${HOME_BACKUP} and creating needed dirs..." | tag 0

    mkdir -p "$HOME_BACKUP" | tag $?
    find "$HOME" -mindepth 1 -maxdepth 1 -name '.*' | grep -v "$DOTFILES_ROOT" | grep -v "$HOME_BACKUP" | xargs -I{} mv -v {} "$HOME_BACKUP"

    mkdir -pv "${HOME}/.config" \
        "${HOME}/.local/src" \
        "${HOME}/.local/bin" \
        "${HOME}/.local/share/fonts"
}

# Add user to needed groups and start services
add_groups_services() {
    echo "Adding user to groups..." | tag 0
    sudo usermod -aG _seatd socklog
    echo "Enabling services..." | tag 0
    for service in _seatd acpid chronyd dbus dhcpcd nanoklogd pcscd polkitd power-profiles-daemon socklog-unix tlp; do
        sudo ln -sf "/etc/sv/${service}" "/var/service/"
        sv start "$service"
    done
}

# Install packages with xbps-install and download some fonts
pkg_install() {
    echo "Installing packages..." | tag 0
    sudo xbps-install -S $(cat pkg-list.txt)

    # My favorite fonts, not all are needed, edit fonts var (see fontconfig)
    echo "Installing fonts..." | tag 0

    font_src="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts"
    font_dir="${HOME}/.local/share/fonts"
    fonts="\
        JetBrainsMono/Ligatures/Regular/JetBrainsMonoNerdFont-Regular.ttf
        Iosevka/Regular/IosevkaNerdFont-Regular.ttf
        Ubuntu/Regular/UbuntuNerdFont-Regular.ttf
        Mononoki/Regular/MononokiNerdFont-Regular.ttf"

    for font in $fonts; do
        curl -OJL --output-dir "$font_dir" "${font_src}/${font}"
    done
}

# Symlink dotfiles, create backup if $dst already exists, then wallpapers
dotfiles_install() {
    for src in $(find "$DOTFILES_ROOT" -name '*.symlink' -not -path '*.git*'); do
        dst="$(echo "$src" | sed -e "s/\.symlink$//g" -e "s|${DOTFILES_ROOT}\/home|$HOME|")"
        if ! [ "$src" -ef "$(readlink "$dst")" ]; then
            if [ -f "$dst" ] || [ -d "$dst" ]; then
                backup="$dst-$(date +%Y-%m-%d)"
                mv --verbose --backup "$dst" "${backup}.backup" | tag $?
            fi
            ln --verbose --symbolic "$src" "$dst" | tag $?
    	fi
    done
}

# Flow
main() {
    printf "My void linux setup script.\nInstalls needed dotfiles, fonts, and packages on a fresh install.\n\n"
    prompt "Initial setup? (creates needed directores and makes a full backup of ~)" && setup
    prompt "Install needed packages and fonts? (needs root access)" && pkg_install
    prompt "Add user to groups and enable services?" && add_groups_services
    prompt "Symlink dotfiles? (will backup duplicate configs automatically)" && dotfiles_install
    echo "Setup completed. Logout and log back in tty1."
}

main
