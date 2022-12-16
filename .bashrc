# shellcheck shell=bash disable=SC1090,SC1091
# There are 3 different types of shells in bash: the login shell, normal shell
# and interactive shell. Login shells read ~/.profile and interactive shells
# read ~/.bashrc; in our setup, /etc/profile sources ~/.bashrc - thus all
# settings made here will also take effect in a login shell.
#
# NOTE: It is recommended to make language settings in ~/.profile rather than
# here, since multilingual X sessions would not work properly if LANG is over-
# ridden in every subshell.

test -s ~/.alias && {
    . ~/.alias || true
}

# Key bindings, up/down arrow searches through history
if [ -t 1 ]; then
    # standard output is a tty
    # do interactive initialization
    bind '"\e[A": history-search-backward'
    bind '"\e[B": history-search-forward'
    bind '"\eOA": history-search-backward'
    bind '"\eOB": history-search-forward'
fi

eval "$(direnv hook bash)"
eval "$(starship init bash)"
eval "$(starship completions bash)"

alias hx="helix"
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

# Preserve MANPATH if you already defined it somewhere in your config.
# Otherwise, fall back to `manpath` so we can inherit from `/etc/manpath`.
export MANPATH="${MANPATH-$(manpath)}:$NPM_PACKAGES/share/man"

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv init --path)"
eval "$(pyenv virtualenv-init -)"

# >>> mamba initialize >>>
# !! Contents within this block are managed by 'mamba init' !!
MAMBA_PATH="$HOME/.local/bin"
export MAMBA_EXE="${MAMBA_PATH}/micromamba"
export MAMBA_ROOT_PREFIX="$PYENV_ROOT/versions/conda"
export MAMBA_NO_BANNER=1

if __mamba_setup="$(
    "$MAMBA_EXE" \
        shell hook \
        --shell bash \
        --prefix "$MAMBA_ROOT_PREFIX" \
        2>/dev/null
)"; then
    eval "$__mamba_setup"
else
    if [ -f "${MAMBA_ROOT_PREFIX}/etc/profile.d/micromamba.sh" ]; then
        . "${MAMBA_ROOT_PREFIX}/etc/profile.d/micromamba.sh"
    else
        export PATH="${MAMBA_ROOT_PREFIX}/bin:$PATH"
    fi
fi
unset __mamba_setup
# <<< mamba initialize <<<

alias amba="micromamba"
complete -o default -F _umamba_bash_completions amba
