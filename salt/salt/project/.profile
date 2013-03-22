if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi

export PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
export CLICOLOR=1
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
export WORKON_HOME=~/.virtualenvs

source /usr/local/bin/virtualenvwrapper.sh

export DJANGO_SETTINGS_MODULE='{{ django_settings_module }}'
export SECRET_KEY='{{ secret_key }}'
