#  Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Git
export PATH=/usr/local/bin/git:$PATH

# peco インクリメンタルサーチ
function select-history() {
    local tac
    if which tac > /dev/null; then
        tac="tac"
    else
        tac="tail -r"
    fi
    BUFFER=$(fc -l -n 1 | eval $tac | peco --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle -R -c
}
zle -N select-history
bindkey '^r' select-history

#  nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# direnv
eval "$(direnv hook zsh)"

# zsh-autosuggestions
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# zsh-syntax-highlighting
source  $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# starship (must be after zsh-autosuggestions and zsh-syntax-highlighting)
eval "$(starship init zsh)"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# エイリアス
alias g='git'
alias -g lb='checkout `git branch --no-color | peco --prompt "GIT BRANCH>" | head -n 1 | sed -e "s/^\*\s*//g"`'

alias ..='cd ..'
alias ls='ls -lGFhA'

alias tf='terraform'

# git index.lockが残った時に安全に削除
gun() {
  local lock="$(git rev-parse --show-toplevel 2>/dev/null)/.git/index.lock"
  if [ -f "$lock" ]; then
    local git_pids
    git_pids=$(lsof -t "$lock" 2>/dev/null | xargs -I{} ps -p {} -o comm= 2>/dev/null | grep -c git)
    if [ "${git_pids:-0}" -eq 0 ]; then
      rm "$lock" && echo "🔓 Removed stale $lock"
    else
      echo "⚠️  Lock is held by an active git process. Not removing."
    fi
  else
    echo "No index.lock found."
  fi
}

[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"

# coreutils
export PATH=$PATH:/usr/local/opt.coreutils/libexec/gnubin

# https://github.com/ajeetdsouza/zoxide
eval "$(zoxide init zsh)"
export PATH="$HOME/.local/bin:$PATH"

# IntelliJ IDEAをコマンドラインから起動するための関数
idea() { open -a "IntelliJ IDEA" "$@"; }

# マシン固有設定（コミットしない）
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
