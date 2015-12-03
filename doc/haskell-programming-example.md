ここにあるのは，「Haskellプログラミングの例」です．筆者自身が「プログラミング環境の使い方をおさらい」した様子を示したものです．もっと上手い使い方があるよ．こうした方がいいよ．というのがあれば是非教えてください．

この記事はまだ未完です．Advent Calendar期間中にすこしずつ書きたします．

(12/03 追記：「ユニットテスト」「stack を使ってテストする」)
(12/02 追記：「shiftSlice 最初の実装」「ドキュメント」)

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

```zsh:.zshenv
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

### ShiftSlice モジュール雛形

src/ShiftSlice.hs を作成．
入出力はあとで考えることにして，文字列から文字列への変換を考える．
とりあえず雛形をいれておく．

```haskell
module ShiftSlice where

shiftSlice :: Int -> String -> String
shiftSlice n = const "Not yet implemented.\n"
````

### コマンド雛形

実行形式のコマンドを作成することになるので，その置き場 app/ を作成する．

```
mkdir app
```

実行形式の項を haskell-programming-example.cabal に追加

```
executable shift-slice
  hs-source-dirs:      app
  main-is:             shift-slice.hs
  ghc-options:         -rtsopts
  build-depends:       base
                     , haskell-programming-example
  default-language:    Haskell2010
```

app/shift-slice.hs を編集．とりあえず，shiftSlice を呼ぶだけ．

```haskell
module Main where

import ShiftSlice

main :: IO ()
main = interact (shiftSlice 3)
```

### build の確認

これでとりあえず build できるかどうか確認．

```
stack build
```

stack build が成功したら，実行ファイルは .stack-work/ 以下のディレクトリに作成される．

```
echo -n "abcdefg" | .stack-work/dist/x86_64-linux/Cabal-1.22.4.0/build/shift-slice/shift-slice
Not yet implemented.
```

これで所定のコマンドを試すための土台はできたかな．

### shiftSlice 最初の実装

文字列から文字列への変換ということで以下の4つの変換を合成することを考える．

(1) 文字列からシフト文字列リストへ変換
(2) 各文字列を先頭n文字までの文字列へ変換
(3) 長さがnになっている文字列のみ採用した文字列リストへ変換
(4) 各文字列を改行文字で終端して，それらを連結して1つの文字列に変換

```haskell
import Data.List (tails)

shiftSlice :: Int -> String -> String
shiftSlice = unlines . takeWhile ((n ==) . length) . make (take n) . tails
```

build して実行してみよう．

```
stack build
echo -n "abcdefg" | .stack-work/dist/x86_64-linux/Cabal-1.22.4.0/build/shift-slice/shift-slice
abc
bcd
cde
def
efg
```

コマンドの雛形ではスライスの大きさを3に固定して shiftSlice を呼んでいることに注意．

### ドキュメント

Haskellのプログラム用のドキュメントシステム Haddock を使うことを前提に，コメントを付けておこう．

```haskell
-- |
-- 文字列をその文字列の各シフトスライスを改行文字で終端して連結した文字列に変換する関数を提供する．
--
--     * スライスとは文字列の先頭から指定した長さ分だけ切り出した文字列
--     * シフトスライスとは文字列を1文字ずつシフトしながら生成したスライス

module ShiftSlice where

import Data.List (tails)

-- | 4つの変換を関数合成する実装
--
--       (1) 文字列からシフト文字列リストへ変換
--       (2) 各文字列を先頭n文字までの文字列へ変換
--       (3) 長さがnになっている文字列のみ採用した文字列リストへ変換
--       (4) 各文字列を改行文字で終端して，それらを連結して1つの文字列に変換

shiftSlice :: Int -> String -> String
shiftSlice n = unlines . takeWhile ((n ==) . length) . map (take n) . tails
```

ドキュメントはスタックを使って生成する．生成したドキュメントは Web ブラウザで読める．

```
stack haddock
google-chrome .stack-work/dist/x86_64-linux/Cabal-1.22.4.0/doc/html/haskell-programming-example/index.html
```

### ユニットテスト

haddock はユニットテストに対応するための記法をサポートしている．

```haskell
-- | 4つの変換を関数合成する実装
--
--       (1) 文字列からシフト文字列リストへ変換
--       (2) 各文字列を先頭n文字までの文字列へ変換
--       (3) 長さがnになっている文字列のみ採用した文字列リストへ変換
--       (4) 各文字列を改行文字で終端して，それらを連結して1つの文字列に変換
--
-- >>> putStr $ shiftSlice 3 "abcdefg"
-- abc
-- bcd
-- cde
-- def
-- efg

shiftSlice :: Int -> String -> String
shiftSlice n = unlines . takeWhile ((n ==) . length) . map (take n) . tails
```

doctest を使って，``>>>`` の行が計算されて結果がそれ以下の記述と一致するかを確認する．

```
stack install doctest
doctest src/ShiftSlice.hs
```

これで，``Examples: 1  Tried: 1  Errors: 0  Failures: 0`` という表示がでれば OK．

### stack を使ってテストする

まず ``haskell-programming-example.cabal`` ファイルに以下のエントリを追加する．

```
test-suite doctest
  type:                exitcode-stdio-1.0
  hs-source-dirs:      test, src
  main-is:             doctesting.hs
  build-depends:       base
                     , haskell-programming-example
                     , doctest
  ghc-options:         -rtsopts
  default-language:    Haskell2010
```

つぎに doctest のテスト実行するプログラム ``test/doctesting.hs`` を作成する．

```haskell
module Main where

import Test.DocTest

main :: IO ()
main = doctest ["src/ShiftSlice.hs"]
```

これで stack を使ってユニットテストができる．

```
stack test
```

(to be continued)