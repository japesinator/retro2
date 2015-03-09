module Screenwriter where

pre :: String
pre = unlines [ "#!/bin/bash"
              , "clear"
              , "red=\'\\033[0;31m\'"
              , "NC=\'\\033[0m\'"
              ]

motd :: String -> String
motd message = "echo -e \"${red}" ++ message ++ "${NC}\""

copy :: Int -> String
copy levelNumber = "cp -a /resources/level_" ++ show levelNumber ++ "/. ./"

aliases :: [(String, String)] -> String
aliases [] = ""
aliases ((command, message) : rest) =
  unlines [ command ++ "fun () {"
          , "  unalias " ++ command
          , "  echo -e \"${red}" ++ message ++ "${NC}\""
          , "  echo"
          , "  " ++ command
          , "}"
          , "alias " ++ command ++ "=\'" ++ command ++ "fun\'"
          ] ++ "\n" ++ aliases rest

screenWrite :: String -> Int -> [(String, String)] -> String
screenWrite m n a = pre ++ "\n" ++ motd m ++ "\n\n" ++ copy n ++ "\n\n" ++ aliases a

makeFile :: String -> Int -> [(String, String)] -> IO ()
makeFile m n a = writeFile "output.sh" $ screenWrite m n a
