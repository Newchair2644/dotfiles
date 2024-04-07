#!/bin/sh
# Install script for my entire system
# Config backups are made automatically in the same dir

# ===== Config ===== #
DOTFILES_ROOT="${HOME}/.dotfiles"   # if you choose to move dotfiles repo elsewhere
HOME_BACKUP="${HOME}/home.bak"      # where to backup existing ~
INSTALL_TYPE="full"                 # choose 'full' for full install, 'base' for cli only


# ===== Helper Functions ===== #
# Generic yes/no prompt
_prompt() {
    printf "\r%s [\033[0;33my/N\033[0m] " "$1"
    read -r input
    case $input in
        [Yy]*) return 0 ;;
        [Nn]*) return 1 ;;
    esac
}

# Add "tags" to output based on $1
_tag() {
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


# ===== "Core Actions" ===== #
# Initial setup (create dirs, backup if needed)
setup() {
    echo "Backing ~/ to ${HOME_BACKUP} and creating needed dirs..." | _tag 0

    mkdir -p "$HOME_BACKUP" | _tag $?
    find "$HOME" -mindepth 1 -maxdepth 1 -name '.*' | grep -v "$DOTFILES_ROOT" | grep -v "$HOME_BACKUP" | xargs -I{} mv -v {} "$HOME_BACKUP"

    mkdir -pv "${HOME}/.config" \
        "${HOME}/.local/src" \
        "${HOME}/.local/bin" \
        "${HOME}/.local/share/fonts"
}

# Install packages with xbps-install and download some fonts
pkg_install() {
    echo "Installing packages..." | _tag 0
    if [ "$INSTALL_TYPE" = "full" ]; then
        pkg=$(sed 's/^!//' pkg-list.txt)
    else
        pkg=$(sed -n 's/^!//p' pkg-list.txt)
    fi
    sudo xbps-install -S $pkg

    # My favorite fonts, not all are needed, edit fonts var (see fontconfig)
    echo "Installing fonts..." | _tag 0

    font_src="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts"
    font_dir="${HOME}/.local/share/fonts"
    fonts="\
        FiraCode/Regular/FiraCodeNerdFont-Regular.ttf
        JetBrainsMono/Ligatures/Regular/JetBrainsMonoNerdFont-Regular.ttf
        Mononoki/Regular/MononokiNerdFont-Regular.ttf
        Iosevka/Regular/IosevkaNerdFont-Regular.ttf
        Ubuntu/Regular/UbuntuNerdFont-Regular.ttf"

    for font in $fonts; do
        curl -OJL --output-dir "$font_dir" "${font_src}/${font}"
    done
}

# Add user to needed groups and start services TODO packages (before groups, also root access???)
add_groups_services() {
    echo "Adding user to groups..." | _tag 0
    sudo usermod -aG dialout,audio,video,kvm,input,users,_seatd,socklog,bluetooth,lpadmin "$(whoami)"
    echo "Enabling services..." | _tag 0
    for service in acpid dbus seatd chronyd pcscd nanoklogd socklog-unix adb tlp cupsd udevd popcorn iwd; do
        sudo ln -sf "/etc/sv/${service}" "/var/service/"
        sv start "$service"
    done
}

# Symlink dotfiles, create backup if $dst already exists, then wallpapers
dotfiles_symlink() {
    for src in $(find "$DOTFILES_ROOT" -name '*.symlink' -o -name '*.base.symlink' -not -path '*.git*'); do
        if [ "$INSTALL_TYPE" = "base" ] && ! echo "$src" | grep -q "\.base.symlink$"; then
            continue
        fi
        
        dst="$(echo "$src" | sed -Ee "s/(\.base)?\.symlink$//g" -e "s|${DOTFILES_ROOT}/home|$HOME|")"
        if ! [ "$src" -ef "$(readlink "$dst")" ]; then
            if [ -f "$dst" ] || [ -d "$dst" ]; then
                backup="$dst-$(date +%Y-%m-%d)"
                mv --verbose --backup "$dst" "${backup}.backup" | _tag $?
            fi
            ln --verbose --symbolic "$src" "$dst" | _tag $?
        fi
    done
}


# ===== Flow ===== #
_main() {
    printf "My void linux setup script.\nInstalls needed dotfiles, fonts, and packages on a fresh install.\n\n"
    _prompt "Initial setup? (creates needed directores and makes a full backup of ~)" && setup
    _prompt "Install needed packages and fonts? (needs root access)" && pkg_install
    [ "$INSTALL_TYPE" = "full" ] && _prompt "Add user to groups and enable services?" && add_groups_services
    _prompt "Symlink dotfiles? (will backup duplicate configs automatically)" && dotfiles_symlink
    echo "Setup completed. Logout and log back in tty1."
}

# Allow optionally running specified action only
if [ -n "$1" ]; then
    case $1 in
        setup) setup ;;
        add-groups-services) add_groups_services ;;
        pkg-install) pkg_install ;;
        dotfiles-symlink) dotfiles_symlink ;;
        dotfiles-unlinked) dotfiles_unlinked ;;
        *) echo "Available options: setup, pkg-install, add-groups-services, dotfiles-symlink" ;;
    esac
else
    _main
fi
