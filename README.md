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
| `config/git/ignore` | グローバル gitignore（XDG準拠） | `~/.config/git/ignore` |
| `config/starship.toml` | Starship プロンプト設定 | `~/.config/starship.toml` |
| `config/karabiner/karabiner.json` | Karabiner キー設定 | `~/.config/karabiner/karabiner.json` |
| `config/gh/config.yml` | gh CLI 設定（非秘匿） | `~/.config/gh/config.yml` |
| `config/cmux/cmux.json` | cmux ターミナル設定（ショートカット等） | `~/.config/cmux/cmux.json` |
| `config/cmux/config.ghostty` | cmux 外観設定（フォント・透過等） | `~/Library/Application Support/com.mitchellh.ghostty/config.ghostty` |
| `config/cmux/hooks/*.sh` | cmux codex 連携フックスクリプト | `~/.cmux/hooks/*.sh` |
| `config/rtk/config.toml` | rtk（トークン圧縮CLI）設定 | `~/.config/rtk/config.toml` |
| `Brewfile` | Homebrew パッケージ一覧 | — |
| `setup.sh` | シンボリックリンク作成スクリプト | — |

> **cmux の設定ファイルについて**
>
> cmux は ghostty ベースのターミナルのため、外観設定（フォント・透過等）は上流 ghostty の設定パスを読む。
> ショートカット等の cmux 独自設定は `~/.config/cmux/cmux.json` 側で管理する。
>
> 設定ファイルの探索順位（cmux 0.64.20 で実測）:
>
> 1. `~/Library/Application Support/com.mitchellh.ghostty/config.ghostty` ← **優先。これを管理対象にしている**
> 2. `~/.config/ghostty/config.ghostty`（XDG）— 1 が存在しない場合のみ読まれる
>
> XDG 側は 1 が存在すると**警告なく無視される**（設定が効かない原因が見えない）ため、確実に効く 1 を採用した。
> なお `~/Library/Application Support/com.cmuxterm.app/config.ghostty` にも同名の空ファイルが生成されるが、現状は未使用。
>
> アプリID `com.mitchellh.ghostty` は上流 ghostty 由来のため、将来 cmux が自前IDへ移行すると 1 が無効化される可能性がある。
> 外観設定が効かなくなったら、まず実効値を確認する:
>
> ```bash
> /Applications/cmux.app/Contents/Resources/bin/ghostty +show-config | grep font-size
> ```

## 秘匿情報の管理

秘匿情報・マシン固有設定は `.local` ファイルに分離し、git 管理しない。

- `~/.zshrc.local` — API キー、トークン、SSH Agent パス
- `~/.gitconfig.local` — user.name/email、signingkey、credential helper
- `~/.config/gh/hosts.yml` — gh CLI の OAuth トークン（**取り込み禁止・`.gitignore` で除外**）

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

新しいツールをインストールした後、Brewfile を**手動で**同期する（アルファベット順を維持）。

> **⚠ `brew bundle dump` で Brewfile を上書きしないこと**
>
> dump はサードパーティ tap の formula を**警告なく出力から落とす**。
> 実測（2026-08-03）では、インストール済みかつ PATH 上に存在する `kayac/tap/ecspresso` が
> dump 出力に1行も含まれなかった。そのまま上書きすると Brewfile からツールが消え、
> 新環境で再現できなくなる。
>
> 加えて dump は以下も混入させる:
>
> - 他マネージャ経由で入れたもの（`go "..."`、`uv "..."` エントリ）
> - 依存として入った formula（`pkgconf` 等。明示する必要がない）

dump は**差分の確認にだけ**使う（採用は1件ずつ人が判断する）:

```bash
brew bundle dump --force --file=/tmp/Brewfile.dump
diff ~/garage/dotfiles/Brewfile /tmp/Brewfile.dump
```

「明示インストールなのに Brewfile に無い formula」だけを列挙するならこちら:

```bash
comm -23 <(brew leaves --installed-on-request | sed 's|.*/||' | sort) \
         <(grep -oE '^brew "[^"]+"' ~/garage/dotfiles/Brewfile | sed 's/brew "//; s/"//; s|.*/||' | sort)
```

### 同期の検証

再現性と鮮度は**別の関心事**なので、コマンドを分けて実行する。

```bash
# 再現性チェック: Brewfile の中身がインストール済みか
brew bundle check --no-upgrade --file=~/garage/dotfiles/Brewfile

# 鮮度チェック: 更新可能なパッケージがあるか
brew outdated
```

`--no-upgrade` を外すと「インストール済みだが最新でない」だけで失敗する。
時間経過だけで赤くなる検証は無視されるようになり、本当にパッケージが欠けているとき
（新マシンのセットアップ時など）の失敗を見逃すため、再現性チェックには必ず付ける。

### cask と tap の対応

cask を追加したら、その提供元 tap も併せて記載する。
tap の記載漏れは `brew bundle check` では検出できず、新環境でのインストール時に初めて失敗する。

## VSCode 拡張

VSCode 拡張は Settings Sync（GitHub アカウント連携）で管理する。Brewfile には含めない。

## レガシーファイルのクリーンアップ

旧構成からの移行時は、`setup.sh` 実行後に以下を確認・削除する:

```bash
# 旧 ~/.gitignore_global symlink（XDG移行で不要）
[ -L ~/.gitignore_global ] && rm ~/.gitignore_global

# ignore ルールが効いているか検証
git check-ignore -v ~/.DS_Store
# → ~/.config/git/ignore:2:.DS_Store ... のように表示されればOK
```
