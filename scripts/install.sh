#!/usr/bin/env bash
set -exu

echo "This file is only for manual thoughtful execution line-by-line"
echo "It may break at any symbol on any line for any possible reason"
echo "It can be not updated with any possible occasion or because I made it so"
echo "It exists only to organize installed sources/software information"
echo "In other words: if you're here with desire to copy-execute something"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! STOP !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"

false
exit 1

sudo zypper rm --clean-deps PackageKit gnome-shell-search-provider-epiphany
sudo zypper addlock PackageKit gnome-shell-search-provider-epiphany

sudo zypper addrepo -n utilites -f -g https://download.opensuse.org/repositories/utilities/openSUSE_Factory/utilities.repo
sudo zypper in --from utilites --recommends bat direnv fzf glow jq opi ripgrep tealdeer
sudo zypper dup --from utilities
sudo zypper in git httpie cmake-full

USERNAME="psydvl"
URL="https://github.com/${USERNAME}/dotfiles"
git clone --mirror $URL ~/.dotfiles
git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" pull --ff-only
git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" submodule update --init

sudo zypper install go yarn flatpak tcl tk
sudo zypper install htop sysprof sysprof-ui wl-clipboard
sudo zypper install 7zip ImageMagick ShellCheck bats ccache cmake-full gh graphviz sqlite3 zathura
sudo zypper install cherrytree epiphany pinta seamonkey sqlitebrowser zeal

sudo zypper addrepo -n mozilla_Factory -f -g https://download.opensuse.org/repositories/mozilla:/Factory/openSUSE_Factory/mozilla:Factory.repo
# sudo zypper install --from mozilla_Factory MozillaFirefox
sudo zypper dup --from mozilla_Factory

sudo zypper addrepo -n editors -f -g https://download.opensuse.org/repositories/editors/openSUSE_Tumbleweed/editors.repo
sudo zypper in --from editors helix lapce

sudo zypper addrepo -n home_sp1rit -f -g https://download.opensuse.org/repositories/home:/sp1rit/openSUSE_Tumbleweed/home:sp1rit.repo
sudo zypper install --from home_sp1rit notekit

opi codecs
sudo zypper modifyrepo -p 90 packman

# https://www.sublimetext.com/docs/linux_repositories.html#zypper
# https://www.sublimemerge.com/docs/linux_repositories#zypper
opi sublime
# https://code.visualstudio.com/docs/setup/linux#_rhel-fedora-and-centos-based-distributions
opi vscode
# http://rpm.anydesk.com/howto.html
opi anydesk
#opi chrome
#opi slack

# sudo zypper in sublime-text sublime-merge code
sudo zypper in --from sublime-text sublime-merge

flatpak remote-add --if-not-exists flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo
flatapk install --from flathub com.anydesk.Anydesk \
    com.mattjakeman.ExtensionManager \
    com.discordapp.DiscordCanary \
    com.github.alainm23.planner \
    com.github.alexkdeveloper.desktop-files-creator \
    com.github.liferooter.textpieces \
    com.github.tchx84.Flatseal \
    com.usebottles.bottles \
    io.github.seadve.Kooha \
    it.mijorus.smile \
    org.gnome.design.Contrast \
    org.gnome.design.Palette \
    org.gnome.gitlab.somas.Apostrophe \
    us.zoom.Zoom

flatapk install --from flathub-beta org.telegram.desktop

# Go

go install golang.org/x/tools/cmd/...@latest
go install golang.org/x/tools/gopls@latest
go install github.com/go-delve/delve/cmd/dlv@latest
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
go install github.com/onsi/ginkgo/v2/ginkgo@latest
go install mvdan.cc/sh/v3/cmd/shfmt@latest
go install mvdan.cc/gofumpt@latest

go install loov.dev/lensm@main
go install gioui.org/cmd/gogio@latest
go install github.com/tanin47/git-notes@@latest

go install github.com/nao1215/gup@latest
# go install github.com/Gelio/go-global-update@latest

go install golang.org/dl/gotip@latest
gotip download

go install github.com/psydvl/exercism-cli@latest

# Rust

# https://rustup.rs/
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

cargo install cargo-binstall
cargo install cargo-update starship

cargo binstall topgrade
mkdir -p ~/.local/bin
if TOPGRADE=$(
    readlink -f "$(which topgrade)"
); then
    cp "$TOPGRADE" ~/.local/bin
    unset TOPGRADE
fi
cargo uninstall topgrade

# Python

# https://github.com/direnv/direnv/wiki/Python

sudo zypper install pyenv python3-pipx

curl micro.mamba.pm/install.sh | bash

pipx install pdm poetry
poetry config virtualenvs.in-project true

pyenv install 3.10

# https://github.com/pyenv/pyenv-virtualenv
git clone https://github.com/pyenv/pyenv-virtualenv.git "$(pyenv root)/plugins/pyenv-virtualenv"

mkdir -p "$(pyenv root)/versions/conda"
amba install -n base conda

# JS/TS

sudo zypper install yarn

mkdir "${HOME}/.npm-packages"
npm config set prefix "${HOME}/.npm-packages"

# Games

sudo zypper addrepo -n games -f -g https://download.opensuse.org/repositories/games/openSUSE_Tumbleweed/games.repo
sudo zypper addrepo -n games_tools -f -g https://download.opensuse.org/repositories/games:/tools/openSUSE_Tumbleweed/games:tools.repo

sudo zypper install --from games_tools --recommends steam gamemoded
sudo zypper install --from games cbonsai minecraft-launcher sl vitetris

# https://github.com/paroj/xpad
sudo git clone https://github.com/paroj/xpad.git /usr/src/xpad-0.4
sudo dkms install -m xpad -v 0.4
cd /usr/src/xpad-0.4
echo "#!/bin/env bash
set -exu
sudo -nv 2>&1

git fetch
git checkout origin/master
dkms remove -m xpad -v 0.4 --all
dkms install -m xpad -v 0.4" | sudo tee /usr/src/xpad-0.4/update.sh

# bloat/crap free minecraft launcher; lighter than official electron-based (what for electron used here?)
# https://github.com/Kron4ek/minecraft-vortex-launcher/releases/latest
# https://files.minecraftforge.net/net/minecraftforge/forge/
# https://www.curseforge.com/minecraft/mc-mods/controllable
mkdir -p ~/.minecraft
pushd ~/.minecraft
version="1.19.3-44.1.2"
wget "https://maven.minecraftforge.net/net/minecraftforge/forge/${version}/forge-${version}-installer.jar"
java -jar "forge-${version}-installer.jar"
rm forge-*
version="1.1.19"
wget "https://github.com/Kron4ek/minecraft-vortex-launcher/releases/download/${version}/VLauncher_${version}_largewindow_x64_Linux"
ln -s "VLauncher_${version}_largewindow_x64_Linux" VLauncher
chmod +x VLauncher
popd

# final

# https://exercism.org/settings/api_cli
xdg-open "https://exercism.org/settings/api_cli"
TOKEN="$(wl-paste)"
exercism configure -t "$TOKEN" -w /home/nixi/work/Projects/exercism/

topgrade
