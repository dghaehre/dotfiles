# Installation notes

This should probably be fixed up and scripts might be created, but for now this is just a document where I dump some notes on how I setup my arch.

must install before reboot:
- sudo
- vi
- networkmanager

## Pacman dependencies:
- nvim
- xorg-server
- i3-wm
- curl
- git
- fakeroot
- ripgrep
- zsh
- man-pages
- man-db
- xdg-utils (for opening url's from alacritty)
- feh
- bc
- fd
- bat
- exa
- fzf
- broot
- less
- stow
- rofi
- clipmenu
- alacritty
- tmux
- starship
- i3lock
- xorg-xset
- xcape
- noto-fonts
- noto-fonts-emoji
- adobe-source-code-pro-fonts
- ttf-font-awesome
- lightdm
- libpulse
- lightdm-gtk-greeter
- base-devel
- newsboat

## AUR dependencies:
- yay
- todotxt
- dropbox

For neomutt
- mutt-wizard
- abook
- lynx
- notmuch

## Other dependencies:
- rustup (needed for i3status-rust. Should be installed with rust script)
- i3status-rust (Should be installed with cargo)
  `cargo install --git https://github.com/greshake/i3status-rust i3status-rs`

## optional packages:
- xf86-video-intel # intel video driver

# commands to run:
- `sudo systemctl enable NetworkManager`
- `sudo systemctl start NetworkManager`
- `sudo systemctl enable lightdm`
- `systemctl enable clipmenud --user`
- `sudo systemctl enable dropbox@$USER`
  You might have to login to dropbox to login.
  You could also check journald for logs and click the link there.

- install nodejs with nvm:
  command example: `curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash`
  install nodejs: `nvm install --lts`

- install vim-plug:
  command: `sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'`



# Setup X server
run `Xorg :0 -configure` to create a xorg.conf file. copy this file to /etc/X11/xorg.conf


## Setup keybase with wikis
```bash
mkdir ~/wikis
sudo pacman -S keybase keybase-gui
```
Login

```bash
cd ~/wikis
git clone keybase://private/dghaehre_/vimwiki personal
```





## installed, but probably not useful:
- xorg-xinit
- pango
