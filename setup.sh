#!/bin/bash
# dotfiles シンボリックリンクセットアップ
# 冪等：何度実行しても安全

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="$HOME/dotfiles-backups/$(date +%Y%m%d_%H%M%S)"

# シンボリックリンク対象の定義
# 形式: "リポジトリ内パス:リンク先パス"
TARGETS=(
  "zshrc:$HOME/.zshrc"
  "gitconfig:$HOME/.gitconfig"
  "gitignore_global:$HOME/.gitignore_global"
)

# 色付き出力
green() { printf "\033[32m%s\033[0m\n" "$1"; }
yellow() { printf "\033[33m%s\033[0m\n" "$1"; }
red() { printf "\033[31m%s\033[0m\n" "$1"; }

echo "=== dotfiles セットアップ ==="
echo "リポジトリ: $SCRIPT_DIR"
echo ""

backup_created=false

for target in "${TARGETS[@]}"; do
  src_rel="${target%%:*}"
  dest="${target##*:}"
  src="$SCRIPT_DIR/$src_rel"

  if [ ! -e "$src" ]; then
    red "スキップ: $src_rel （リポジトリ内に存在しません）"
    continue
  fi

  if [ -L "$dest" ]; then
    current_target="$(readlink "$dest")"
    if [ "$current_target" = "$src" ]; then
      green "✓ $src_rel → $dest （リンク済み）"
      continue
    else
      yellow "  更新: $dest （旧リンク先: $current_target）"
      rm "$dest"
    fi
  elif [ -e "$dest" ]; then
    if [ "$backup_created" = false ]; then
      mkdir -p "$BACKUP_DIR"
      backup_created=true
    fi
    yellow "  バックアップ: $dest → $BACKUP_DIR/$src_rel"
    mv "$dest" "$BACKUP_DIR/$src_rel"
  fi

  ln -s "$src" "$dest"
  green "✓ $src_rel → $dest （新規作成）"
done

# === .local ファイルの確認 ===
echo ""
echo "=== .local ファイルの確認 ==="

if [ ! -f "$HOME/.zshrc.local" ]; then
  yellow "未作成: ~/.zshrc.local"
  yellow "  → cp $SCRIPT_DIR/zshrc.local.example ~/.zshrc.local して値を設定してください"
else
  green "✓ ~/.zshrc.local が存在します"
fi

if [ ! -f "$HOME/.gitconfig.local" ]; then
  yellow "未作成: ~/.gitconfig.local"
  yellow "  → cp $SCRIPT_DIR/gitconfig.local.example ~/.gitconfig.local して値を設定してください"
else
  green "✓ ~/.gitconfig.local が存在します"
fi

# === Homebrew パッケージ ===
echo ""
echo "=== Homebrew パッケージ ==="

if [ -f "$SCRIPT_DIR/Brewfile" ]; then
  if command -v brew > /dev/null 2>&1; then
    yellow "Brewfile が見つかりました。パッケージをインストールするには:"
    yellow "  → brew bundle install --file=$SCRIPT_DIR/Brewfile"
    yellow "現在の環境を Brewfile に反映するには:"
    yellow "  → brew bundle dump --force --file=$SCRIPT_DIR/Brewfile && sed -i '' '/^vscode /d' $SCRIPT_DIR/Brewfile"
  else
    yellow "Homebrew が見つかりません。先にインストールしてください: https://brew.sh"
  fi
else
  yellow "Brewfile が見つかりません"
fi

echo ""
echo "=== 完了 ==="

if [ "$backup_created" = true ]; then
  yellow "バックアップ先: $BACKUP_DIR"
fi

echo ""
echo "現在のシンボリックリンク状態:"
for target in "${TARGETS[@]}"; do
  dest="${target##*:}"
  if [ -L "$dest" ]; then
    echo "  $dest -> $(readlink "$dest")"
  elif [ -e "$dest" ]; then
    echo "  $dest （通常ファイル/ディレクトリ）"
  else
    echo "  $dest （存在しません）"
  fi
done
