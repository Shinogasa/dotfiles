eval "$(pyenv virtualenv-init -)"
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi

#export LSCOLORS=gxfxcxdxbxegedabagacad
alias ls="ls -G"
alias ll="ls -lG"
alias la="ls -laG"
eval "$(rbenv init -)"
export PLENV_ROOT=$HOME/.plenv
export PATH=$PLENV_ROOT/bin:$PATH
eval "$(plenv init -)"
export PATH=$HOME/.nodebrew/current/bin:$PATH
