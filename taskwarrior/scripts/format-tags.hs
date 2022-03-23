#!/usr/bin/env stack
-- stack --resolver lts-18.13 script
import System.Environment

main :: IO ()
main = do
  list <- words . map comma <$> getLine
  putStrLn $ foldl show' "" list
  where
    comma ',' = ' '
    comma c = c
    show' a s = a ++ "+" ++ s ++ " "
