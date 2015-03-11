module Screenwriter where

pre :: String
pre = unlines [ "#!/bin/bash"
              , ""
              -- Get rid of remnants of last level
              , "clear"
              , "unalias -a"
              , ""
              -- For pretty text
              , "red=\'\\033[0;31m\'"
              , "NC=\'\\033[0m\'"
              ]

-- The message that shows at the start of the level, ideally giving some
-- information about the solution
motd :: String -> String
motd message = "echo -e \"${red}" ++ message ++ "${NC}\""

-- Move in new files. Note that the behavior of copy here will overwrite
-- old files with the same name, but not all files
copy :: String -> Int -> String
copy course level = "cp -a /resources/" ++ course ++ "/level_" ++ show level ++ "/. ./"

-- Set up messages to show on first use of commands
aliases :: [(String, String)] -> String
aliases [] = ""
aliases ((command, message) : rest) =
  unlines [ command ++ "fun () {"
          , "  unalias " ++ command
          , "  echo -e \"${red}" ++ message ++ "${NC}\""
          , "  echo"
          , "}"
          -- The `&& command` assures that flags will get passed through
          , "alias " ++ command ++ "=\'" ++ command ++ "fun &&" ++ command ++ "\'"
          ] ++ "\n" ++ aliases rest

screenWrite :: String -> String -> Int -> [(String, String)] -> String
screenWrite m s n a = pre ++ "\n"
                   ++ motd m ++ "\n\n"
                   ++ copy s n ++ "\n\n"
                   ++ aliases a

makeFile :: String -> String -> Int -> [(String, String)] -> IO ()
makeFile m s n a = writeFile "output.sh" $ screenWrite m s n a
