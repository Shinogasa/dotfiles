# How to use


自分のディレクトリにdotfilesという名のフォルダを作る。

```
$ cd
$ mkdir dotfiles
```
現行のファイルをdotfiles配下に移す。（私は好みで先頭にドットを付けると隠れファイルになるのがイヤでドットを付けないファイル名としている。ここはお好み次第）
```
$ mv .vimrc dotfiles/vimrc
$ mv .bash_profile dotfiles/bash_profile
$ mv .agignore dotfiles/agignore
$ mv .tmux.conf dotfiles/tmux.conf
```
管理したいファイル分を繰り返す

シンボリックリンクを作成する。以下の内容のシェルスクリプトを作成し、dotfiles_links.shという名で保存する。
```
ln -sf ~/dotfiles/vimrc ~/.vimrc
ln -sf ~/dotfiles/bash_profile ~/.bash_profile
ln -sf ~/dotfiles/agignore ~/.agignore
ln -sf ~/dotfiles/tmux.conf ~/.tmux.conf
```
実行権を与えて、実行する。
```
$ chmod +x dotfiles_link.sh
$ ./dotfiles_link.sh
```
GitHubにログインして左上の＋ボタンを押す。新しいリポジトリを作る。リポジトリ名はdotfilesとしておく。
```
$ git init
$ git add .
$ git commit -m "first commit"
$ git remote add origin git@github.com:<Your Account Name>/dotfiles.git
$ git push -u origin master
```
他のコンピュータにこの設定を持ってくる時
```
$ cd
$ git clone https://github.com/<Your Account Name>/dotfiles.git
$ cd dotfiles
$ chmod +x dotfiles_link.sh
$ ./dotfiles_link.sh
```


> Thanks! ジャバ・ザ・ハットリ   
> http://tango-ruby.hatenablog.com/entry/2017/02/07/235714