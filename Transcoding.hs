module Transcoding where

import Control.Monad (replicateM)
import Math
import Numeric (showHex, readHex)
import Data.Char (ord, chr)
import Data.List (elemIndex)

-- wandelt eine Dezimalzahl in eine Hexadezimalzahl um (Rückgabe als String)
decToHex :: (Show a, Integral a) => a -> String
decToHex dec = do
  let hex = showHex dec ""
  if length hex == 1 then "0" ++ hex else hex
  
hexToDec :: (Integral a) => String -> a
hexToDec hex = case readHex hex of
               (dec, _):_ -> dec
               _          -> error "Invalid hex"

-- konvertiert jeden Buchstaben eines gegebenen Strings in den zugehörigen hexadezimalen ASCII-Wert
-- map wendet auf jedes Zeichen des Strings die verkettete Funktion aus ord (Zeichen in dezimal ASCII) und decToHex an
-- Rückgabe als Array der ASCII-Werte
stringToOctetStream :: String -> [String]
stringToOctetStream = map (decToHex . ord)

split :: Int -> String -> [String]
split n str = case splitAt n str of
              (a, b) | null a    -> []
                     | otherwise -> a : split n b

generatePaddingString :: Int -> Int -> IO [String]
generatePaddingString k mLen = do
  let paddingLength = div k 8 - mLen - 3
  randomIntegers <- replicateM paddingLength (randomInt(1, 254))
  return $ map decToHex randomIntegers

encode :: String -> Int -> IO [String]
encode m keyLength = do
  paddingString <- generatePaddingString keyLength (length m)
  let message = stringToOctetStream m
  return $ ["00", "02"] ++ paddingString ++ ["00"] ++ message

decode :: [String] -> IO String
decode em = do
  let mes = (drop 1 . dropWhile (/= "00") . drop 2) em
  let decMes = map hexToDec mes
  let ascii = map (chr . fromIntegral) decMes
  return ascii