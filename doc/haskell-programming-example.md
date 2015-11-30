ここにあるのは，「Haskellプログラミングの例」です．
筆者自身がプログラミング環境をおさらいした様子を示したものです．

もっと上手い使い方があるよ．こうした方がいいよ．というのがあれば是非教えてください．
この記事はまだ未完です．Advent Calendar期間中にすこしずつ書きたします．

## プログラミング環境そのものの準備

### gitのインストール

Ubuntu 14.04 LTS (64bit)の場合

```
sudo apt-get install -y git-core
```

その他の環境ではそれなりに．

### stack のインストール

これもUbuntu 14.04 LTS (64bit)の場合のみ示します．
[stack本家ドキュメント](http://docs.haskellstack.org/en/stable/install_and_upgrade.html#ubuntu)そのまま．

```
echo 'deb http://download.fpcomplete.com/ubuntu/trusty stable main'|sudo tee /etc/apt/sources.list.d/fpco.list
sudo apt-get update && sudo apt-get install stack -y
```

### GHC 7.10.2 のインストール

stackを使って，

```
stack update
stack setup 7.10.2
```

### 環境変数の設定

```zsh: .zshenv
GHC_VERSION=ghc-7.10.2
GHC_PATH=$HOME/.stack/programs/x86_64-linux/$GHC_VERSION/bin
export PATH=$HOME/.local/bin:$GHC_PATH:$PATH
```

### cabal-installのインストール

```
stack install cabal-install
```

### ghc-modのインストール

ghc-modのインストールにはstack.yamlのextra-depsにcabal-helperの版番0.7未満0.6.1.0以上を指定する

```yaml:stack.yaml
flags: {}
extra-package-dbs: []
packages: []
extra-deps:
- cabal-helper-0.6.2.0
resolver: lts-3.16
```

stackを使ってghc-modをインストール

```
stack install ghc-mod
```

## プロジェクトの作成

### GitHub

新しいリポジトリ作成

- Repository: haskell-programming-example
- Description: An Haskell Programming Example with GitHub and stack
- Public
- Initialize this repository with a README
- Add .gitignore: Haskell
- Add a license: BSD 3-clause "New" or "Revised" License

- [Create repository]


リポジトリをローカルに clone して，そこに移動．

```
git clone git@github.com:nobsun/haskell-programming-example.git
cd haskell-programming-example
```

### ディレクトリ構成

git clone 直後

```
  +-- .git/
  +-- .gitignore
  +-- LICENSE
  +-- README.md
```

cabalファイルの雛形を作成

```
cabal init
```

この時点でのディレクトリ構成

```
  +-- .git/
  +-- .gitignore
  +-- LICENSE
  +-- README.md
  +-- Setup.hs
  +-- haskell-programming-example.cabal
```

src/ にライブラリモジュール ShiftSlice を置く予定
haskell-programming-example.cabalを編集

```
name:                haskell-programming-example
version:             0.1.0.0
synopsis:            Shift Slice Filter
description:         This project is for demonstarating a short haskell programming example.
homepage:            http://github.com/nobsun/haskell-programming-example/
license:             BSD3
license-file:        LICENSE
author:              nobsun
maintainer:          xxxxx@xxxxxx.xxx
build-type:          Simple
extra-source-files:  README.md
cabal-version:       >=1.10

library
  exposed-modules:     ShiftSlice
  build-depends:       base >=4.8 && <4.9
  hs-source-dirs:      src
  default-language:    Haskell2010
```

src/ を作成

```
mkdir src
```

### stack初期化

```
stack init
```

直後のディレクトリ構成

```
  +-- .git/
  +-- .gitignore
  +-- .stack-work/
  +-- LICENSE
  +-- README.md
  +-- Setup.hs
  +-- haskell-programming-example.cabal
  +-- stack.yaml
```

.stack-work/ と stack.yamlはローカル環境でのみ有効なので .gitignore に登録

## プログラミング

プログラムの課題は以下にあったもの．

- [勝手にお題---テキストフィルタ](http://blog.practical-scheme.net/shiro/20151103-gauche-example)
- [8つの言語でテキストフィルタを書き比べた](http://d.hatena.ne.jp/eel3/20151102/1446476928)

[8つの言語でテキストフィルタを書き比べた](http://d.hatena.ne.jp/eel3/20151102/1446476928)によれば，

> テキストファイルの先頭から指定したbyte数（または文字数）だけ出力し、改行を出力し、先頭から1byte（または1文字）シフトした位置から同じように出力し、改行を出力し、再びシフトし――ということをファイル終端まで繰り返すコンソールアプリだ。例えばこんな感じ。
>
> ```
> $ echo -n abcd | hcasl -n 1
> a
> b
> c
> d
> $ echo -n abcd | hcasl -n 2
> ab
> bc
> cd
> $ echo -n abcd | hcasl -n 3
> abc
> bcd
> ```

というテキストフィルタを書くというもの

### ShiftSlice モジュール

src/ShiftSlice.hs を作成．
入出力はあとで考えることにして，文字列から文字列への変換を考える．


1. 入力文字列を順次シフトした文字列リストへ変換
2. すべてのシフト文字列に文字列の先頭からn文字とりだす関数(take n)を適用
3. 文字列リストの先頭から，長さが指定した数nになっている間，文字列をとりだす
4. それぞれの文字列の末尾に改行文字を追加して各文字列を連結する

これをそのままコードにしてみよう．

```haskell
shiftSlice :: Int -> String -> String
shiftSlice n = unlines . takeWhile ((n ==) . length) . map (take n) . tails
```

確認してみよう．

```
λ> putStr $ shiftSlice 3 "abcdefgh"
abc
bcd
cde
def
efg
fgh
```


未完(続きは後ほど)