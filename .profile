# shellcheck shell=sh
# This file is read each time a login shell is started.
# All other interactive shells will only read .bashrc; this is particularly
# important for language settings, see below.

# shellcheck source=/dev/null
test -z "$PROFILEREAD" && {
    . /etc/profile || true
}

# For some news readers it makes sense to specify the NEWSSERVER variable here
#export NEWSSERVER=your.news.server

tabs 4

export HISTSIZE=10000
export HISTFILESIZE=10000

VI_PATH=$(which vi)
VIM_PATH=$(which vim)

export EDITOR="$VI_PATH"
export VISUAL="$VIM_PATH"

export QT_QPA_PLATFORM="wayland;xcb"
export QT_QPA_PLATFORMTHEME="gnome"
export MOZ_ENABLE_WAYLAND=1

export GOPRIVATE="github.com/psydvl,github.com/EcoMSU"

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

NPM_PACKAGES="${HOME}/.npm-packages"
GO_PATH=$(go env GOPATH)
export PATH="$PATH:$GO_PATH/bin:$NPM_PACKAGES/bin"
export PATH="$PATH:${HOME}/.cargo/bin"
export PATH="$PATH:${HOME}/.local/bin"
export PATH="$PATH:${HOME}/.local/share/JetBrains/Toolbox/scripts"
