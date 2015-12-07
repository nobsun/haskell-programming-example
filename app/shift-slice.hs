{-# LANGUAGE DataKinds #-}
module Main where

import Control.Applicative ((<$>))
import Control.Exception
import Control.Monad
import Control.Monad.Trans (liftIO)
import Data.Traversable (forM)
import System.IO
import Options.Declarative
import ShiftSlice

main :: IO ()
main = run_ shift_slices

shift_slices :: Flag "n" '["slice-size"] "NUMBER" "size of a slice" (Def "3" Int)
             -> Flag "o" '["output"] "FILE" "output file" (Def "-" FilePath)
             -> Arg "[FILEPATH]" [FilePath]
             -> Cmd "Shift slicing" ()
shift_slices n o args = case get args of
  [] -> liftIO $ bracket hdl hClose $ wrap (shiftSlice (get n)) stdin
  fs -> liftIO $ bracket hdl hClose $ forM_ fs . shift_slice (get n)
  where
    hdl = if out == "-" then return stdout else openFile out WriteMode
    out = get o

shift_slice :: Int -> Handle -> FilePath -> IO ()
shift_slice n o fp
  = join $  either (hPutStrLn stderr . show') return
        <$> try (withFile fp ReadMode (flip (wrap (shiftSlice n)) o))

wrap :: (String -> String) -> Handle -> Handle -> IO ()
wrap f i o
  = join  $  either (hPutStrLn stderr . show') (hPutStr o . f)
         <$> try (hGetContents i)

show' :: SomeException -> String
show' = show
