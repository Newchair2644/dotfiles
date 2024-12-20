## Dotfiles
<img src="https://raw.githubusercontent.com/Newchair2644/dotfiles/master/screenshots/gruvbox-dark-medium.png" alt="img" align="right" width="280">

Dotfiles for the most based distro known to man

- **OS**: [Void Linux](https://voidlinux.org)
- **WM**: [Swaywm](https://github.com/swaywm/sway)
- **Shell**: [Bash](https://git.savannah.gnu.org/git/bash.git)
- **Terminal**: [Foot](https://codeberg.org/dnkl/foot)
- **Editor**: [Kakoune](https://kakoune.org)
- **File Manager**: [NNN](https://github.com/jarun/nnn)
- **Base16 Color Scheme Manager**: [Flavours](https://www.nordtheme.com)

Scripts and configs are written with portability in mind, but ***things may break***. Do not blindly use this setup, use it at your own risk. (also I kinda need to add text here so the formatting looks nice :))

## Setup
1. Clone this repository into ~/.dotfiles
2. Run the installer script. It will back up existing configs, create needed directories, install packages, and symlink configs. Make sure to review packages in `pkg-list.txt` beforehand. It will **not** do partitioning or user management, nor will it copy configs in `./system`. Those tasks are best done manually.
   **The script requres root access with `sudo`**. To use `opendoas` instead, symlink `doas` to `sudo` (you probably want this anyway). Also make sure to be in the `wheel` group beforehand.
3. 💰💲💸 Profit!

## Gallery
<details>

<summary>click to view</summary>
<img src="https://raw.githubusercontent.com/Newchair2644/dotfiles/master/screenshots/catppuccin.png" alt="img" align="center" width="900px">

<img src="https://raw.githubusercontent.com/Newchair2644/dotfiles/master/screenshots/gruvbox-dark-medium.png" alt="img" align="center" width="900px">

<img src="https://raw.githubusercontent.com/Newchair2644/dotfiles/master/screenshots/paradise.png" alt="img" align="center" width="900px">

<img src="https://raw.githubusercontent.com/Newchair2644/dotfiles/master/screenshots/gallery-01.png" alt="img" align="center" width="900px">

<img src="https://raw.githubusercontent.com/Newchair2644/dotfiles/master/screenshots/gallery-02.png" alt="img" align="center" width="900px">
</details>
