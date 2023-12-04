module Main where

import Math
import Transcoding
import Cryptography
import Key

alice :: IO (Key, Key)
alice = getKeyPair 1024

main :: IO()
main = do
  keyPair1 <- alice

  let (pub1, priv1) = keyPair1

  let keyLength = calcKeyLength pub1
  print keyLength
  let hexString = stringToOctetStream "f"
  print hexString

  encryptionOutput <- encrypt "helloworld" pub1
  print encryptionOutput
  
  decryptionOutput <- decrypt priv1 encryptionOutput
  print decryptionOutput