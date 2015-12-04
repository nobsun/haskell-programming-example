{-# LANGUAGE DataKinds #-}
module Main where

import Control.Monad.Trans (liftIO)
import Options.Declarative
import ShiftSlice

main :: IO ()
main = run_ shift_slice

shift_slice :: Flag "n" '["slice-size"] "NUMBER" "size of a slice" (Def "3" Int)
            -> Cmd "Shift slicing" ()
shift_slice n = liftIO $ putStr . shiftSlice (get n) =<< getContents
                     
