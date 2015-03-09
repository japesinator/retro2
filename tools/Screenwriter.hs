module Screenwriter where

pre :: String
pre = unlines [ "#!/bin/bash"
              , "clear"
              , "red=\'\\033[0;31m\'"
              , "NC=\'\\033[0m\'"
              ]

motd :: String -> String
motd message = "echo -e \"${red}" ++ message ++ "${NC}\""

copy :: String -> Int -> String
copy course level = "cp -a /resources/" ++ course ++ "/level_" ++ show level ++ "/. ./"

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

screenWrite :: String -> String -> Int -> [(String, String)] -> String
screenWrite m s n a = pre ++ "\n"
                   ++ motd m ++ "\n\n"
                   ++ copy s n ++ "\n\n"
                   ++ aliases a

makeFile :: String -> String -> Int -> [(String, String)] -> IO ()
makeFile m s n a = writeFile "output.sh" $ screenWrite m s n a
