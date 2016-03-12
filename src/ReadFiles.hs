module ReadFiles where
import System.Directory
import System.FilePath.Posix

--- filter only .fa files (for testing purposes, take only 3 for now)
filterFastaFiles :: [FilePath] -> [FilePath]
filterFastaFiles files = take 3 [file | file <- files, takeExtension file == ".fa"]

appendGenomeDir :: String -> [FilePath] -> [FilePath]
appendGenomeDir dir files = map (\file -> joinPath [dir, file]) files

--- Probably don't need this function at all, because outside of IO
--- it can only check that there are files in the list
verifyFilesList :: [FilePath] -> Bool
verifyFilesList [] = False
verifyFilesList _ = True

-- read directory
readGenomeDir :: String -> IO [String]
readGenomeDir dir = do
  files <- getDirectoryContents dir
  let filteredFiles = appendGenomeDir dir (filterFastaFiles files)
  return filteredFiles

-- read files
readFiles :: String -> IO ()
readFiles dir = do
  files <- readGenomeDir dir
  contents <- mapM readFile files
  mapM_ (putStrLn . (take 100)) contents
  return ()
