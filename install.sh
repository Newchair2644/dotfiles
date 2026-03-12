#!/bin/sh
# Install script for my entire system
# Config backups are made automatically in the same dir


# ===== Config ===== #
DOTFILES_ROOT="${HOME}/.dotfiles"
HOME_BACKUP="${HOME}/home.bak"


# ===== Colors ===== #
C_RESET="\033[0m"
C_BOLD="\033[1m"
C_GREEN="\033[32m"
C_RED="\033[31m"
C_YELLOW="\033[33m"
C_CYAN="\033[36m"


# ===== Helper Functions ===== #
_header() {
    printf "\n${C_BOLD}${C_CYAN}==> %s${C_RESET}\n" "$1"
}

_ok()    { printf "${C_GREEN}  ✓${C_RESET} %s\n" "$1"; }
_err()   { printf "${C_RED}  ✗${C_RESET} %s\n" "$1"; }
_info()  { printf "${C_YELLOW}  →${C_RESET} %s\n" "$1"; }

_tag() {
    while read -r line; do
        [ $1 -eq 0 ] && _ok "$line" || _err "$line"
    done
}

_prompt() {
    printf "\n${C_BOLD}%s${C_RESET} [${C_YELLOW}y/N${C_RESET}] " "$1"
    read -r input
    case $input in
        [Yy]*) return 0 ;;
        *)     return 1 ;;
    esac
}


# ===== Core Actions ===== #
setup() {
    _header "Initial Setup"
    _info "Backing up ~/ to ${HOME_BACKUP}"
    mkdir -p "$HOME_BACKUP" | _tag $?
    find "$HOME" -mindepth 1 -maxdepth 1 -name '.*' \
        | grep -v "$DOTFILES_ROOT" \
        | grep -v "$HOME_BACKUP" \
        | xargs -I{} mv -v {} "$HOME_BACKUP" | _tag 0

    _info "Creating directories"
    mkdir -pv \
        "${HOME}/.config" \
        "${HOME}/.local/src" \
        "${HOME}/.local/bin" \
        "${HOME}/.local/share/fonts" | _tag $?
}

pkg_install() {
    _header "Packages"
    for f in "${DOTFILES_ROOT}"/pkgs/*.txt; do
        name=$(basename "$f" .txt)
        [ "$name" = "virt" ] && [ -z "$INSTALL_VIRT" ] && continue
        _info "Installing ${name}"
        xbps-install -S $(grep -Ev '^\s*#|^\s*$' "$f") | _tag $?
    done

    _header "Fonts"
    font_src="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts"
    font_dir="${HOME}/.local/share/fonts"
    fonts="
        FiraCode/Regular/FiraCodeNerdFont-Regular.ttf
        JetBrainsMono/Ligatures/Regular/JetBrainsMonoNerdFont-Regular.ttf
        Mononoki/Regular/MononokiNerdFont-Regular.ttf
        Iosevka/Regular/IosevkaNerdFont-Regular.ttf
        Ubuntu/Regular/UbuntuNerdFont-Regular.ttf"

    for font in $fonts; do
        name=$(basename "$font")
        _info "Downloading ${name}"
        curl -fsSL --output "${font_dir}/${name}" "${font_src}/${font}" \
            && _ok "$name" || _err "Failed: $name"
    done
}

add_groups_services() {
    _header "Groups"
    sudo usermod -aG dialout,kvm,users,_seatd,socklog,bluetooth,lpadmin "$(whoami)" \
        && _ok "Groups updated" || _err "Failed to update groups"

    _header "Services"
    for service in acpid adb bluetoothd chronyd cupsd dbus dhcpcd \
               nanoklogd pcscd polkitd popcorn seatd socklog-unix \
               sshd tlp turnstiled wpa_supplicant; do
        sudo ln -sf "/etc/sv/${service}" "/var/service/" \
            && sv start "$service" \
            && _ok "$service" || _err "$service"
    done

    if [ -n "$INSTALL_VIRT" ]; then
        _header "Virt Services"
        for service in docker libvirtd virtlockd virtlogd; do
            sudo ln -sf "/etc/sv/${service}" "/var/service/" \
                && sv start "$service" \
                && _ok "$service" || _err "$service"
        done
    fi
}

dotfiles_symlink() {
    _header "Symlinking Dotfiles"
    for src in $(find "$DOTFILES_ROOT" -name '*.symlink' -not -path '*/.git/*'); do
        dst="$(echo "$src" | sed -e "s|\.symlink$||" -e "s|${DOTFILES_ROOT}/home|${HOME}|")"
        if ! [ "$src" -ef "$(readlink "$dst")" ]; then
            if [ -f "$dst" ] || [ -d "$dst" ]; then
                backup="${dst}-$(date +%Y-%m-%d).backup"
                _info "Backing up $(basename "$dst")"
                mv --backup "$dst" "$backup" | _tag $?
            fi
            ln --symbolic "$src" "$dst" \
                && _ok "$dst" || _err "$dst"
        else
            _info "Already linked: $(basename "$dst")"
        fi
    done
}


# ===== Flow ===== #
_main() {
    printf "${C_BOLD}${C_CYAN}"
    printf "  _           _        _ _\n"
    printf " (_)_ __  ___| |_ __ _| | |\n"
    printf " | | '_ \/ __| __/ _\` | | |\n"
    printf " | | | | \__ \ || (_| | | |\n"
    printf " |_|_| |_|___/\__\__,_|_|_|\n"
    printf "${C_RESET}\n"
    printf "  Void Linux setup — %s\n\n" "$(date +%Y-%m-%d)"

    _prompt "Install virtualisation packages and services?" && INSTALL_VIRT=1

    _prompt "Initial setup? (creates dirs and backs up ~/)"  && setup
    _prompt "Install packages and fonts? (needs root)"       && pkg_install
    _prompt "Add user to groups and enable services?"        && add_groups_services
    _prompt "Symlink dotfiles? (auto-backs up conflicts)"    && dotfiles_symlink

    printf "\n${C_GREEN}${C_BOLD}Done.${C_RESET} Log out and back in on tty1.\n\n"
}

if [ -n "$1" ]; then
    case $1 in
        setup)               setup ;;
        pkg-install)         pkg_install ;;
        add-groups-services) add_groups_services ;;
        dotfiles-symlink)    dotfiles_symlink ;;
        *) printf "Usage: %s [setup|pkg-install|add-groups-services|dotfiles-symlink]\n" "$0" ;;
    esac
else
    _main
fi
