-- |
-- 文字列の各シフトスライスを改行文字で終端して連結した文字列に変換する関数を提供する．
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
--
-- >>> putStr $ shiftSlice 3 "abcdefg"
-- abc
-- bcd
-- cde
-- def
-- efg

shiftSlice :: Int -> String -> String
shiftSlice n = unlines . takeWhile ((n ==) . length) . map (take n) . tails

