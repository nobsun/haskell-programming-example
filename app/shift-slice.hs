module Main where

import ShiftSlice

main :: IO ()
main = interact (shiftSlice 3)
