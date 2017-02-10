. /Users/Nozomi/.bash_profile
alias vi='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim "$@"'
alias vim='env_LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim "$@"'
eval "$(pyenv virtualenv-init -)"
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi

export PATH=$HOME/.plenv/bin:$PATH
eval "$(plenv init -)"
#alias ls="ls -G"
#alias ll="ls -lG"
#alias la="ls -laG"
