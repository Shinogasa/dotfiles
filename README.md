# dotfiles

macOS 開発環境の dotfiles 管理リポジトリ。

## セットアップ

```bash
# 1. リポジトリをクローン
git clone <repo-url> ~/garage/dotfiles
cd ~/garage/dotfiles

# 2. Homebrew パッケージをインストール
brew bundle install --file=Brewfile

# 3. .local ファイルを作成（秘匿情報を設定）
cp zshrc.local.example ~/.zshrc.local
cp gitconfig.local.example ~/.gitconfig.local
# → 各ファイルを編集して実際の値を入力

# 4. シンボリックリンクを作成
bash setup.sh

# 5. シェルを再読み込み
source ~/.zshrc
```

## ファイル構成

| ファイル | 説明 | リンク先 |
|---|---|---|
| `zshrc` | Zsh 設定（共通部分） | `~/.zshrc` |
| `zshrc.local.example` | マシン固有設定のテンプレート | — |
| `gitconfig` | Git 設定（共通部分） | `~/.gitconfig` |
| `gitconfig.local.example` | マシン固有 Git 設定のテンプレート | — |
| `gitignore_global` | グローバル gitignore | `~/.gitignore_global` |
| `Brewfile` | Homebrew パッケージ一覧 | — |
| `setup.sh` | シンボリックリンク作成スクリプト | — |

## 秘匿情報の管理

秘匿情報・マシン固有設定は `.local` ファイルに分離し、git 管理しない。

- `~/.zshrc.local` — API キー、トークン、SSH Agent パス
- `~/.gitconfig.local` — user.name/email、signingkey、credential helper

## zshrc が依存するツール

以下のツールは `zshrc` 内で直接参照されており、Homebrew でインストールが必要。

| ツール | 用途 | zshrc での使用箇所 |
|---|---|---|
| `peco` | インクリメンタルサーチ | `select-history()`, `lb` エイリアス |
| `nvm` | Node.js バージョン管理 | `nvm.sh` の source |
| `direnv` | ディレクトリ別環境変数 | `direnv hook zsh` |
| `zsh-autosuggestions` | コマンド補完候補の表示 | `source` で読み込み |
| `zsh-syntax-highlighting` | コマンド構文ハイライト | `source` で読み込み |
| `starship` | プロンプトカスタマイズ | `starship init zsh` |
| `zoxide` | ディレクトリ移動の高速化 | `zoxide init zsh` |
| `git` | バージョン管理 | `gun()`, エイリアス群 |

## Brewfile の更新

新しいツールをインストールした後、Brewfile を同期する:

```bash
brew bundle dump --force --file=~/garage/dotfiles/Brewfile
# VSCode 拡張を除外（Settings Sync で管理するため）
sed -i '' '/^vscode /d' ~/garage/dotfiles/Brewfile
```

## VSCode 拡張

VSCode 拡張は Settings Sync（GitHub アカウント連携）で管理する。Brewfile には含めない。
