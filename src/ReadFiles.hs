module ReadFiles where
import System.Directory
import System.FilePath.Posix
import Control.Monad.Writer
import Debug.Trace

--- filter only .fa files (for testing purposes, take only 3 for now)
filterFastaFiles :: [FilePath] -> Writer [String] [FilePath]
filterFastaFiles files = writer (fastaFiles,
                                  ["Reading " ++ (show $ length fastaFiles) ++ " fasta files."])
  where
    fastaFiles = take 3 [file | file <- files, takeExtension file == ".fa"]

--- append dir path to fasta files, so there is a full path
appendGenomeDir :: String -> [FilePath] -> Writer [String] [FilePath]
appendGenomeDir dir files = writer (appendedFiles,
                                    ["Dir path: " ++ dir])
  where
    appendedFiles = map (\file -> joinPath [dir, file]) files

-- read directory
readGenomeDir :: String -> IO (Writer [String] [FilePath])
readGenomeDir dir = do
  files <- getDirectoryContents dir
  return $ (return files) >>= filterFastaFiles >>= (appendGenomeDir dir)

readFiles :: String -> IO ()
readFiles dir = do
    files <- runWriterT $ readGenomeDir' dir
    mapM_ putStrLn (snd $ files)
    contents <- mapM readFile (fst $ files)
    mapM_ (putStrLn . (take 100)) contents
    return ()

liftWriter :: Writer [String] [FilePath] -> WriterT [String] IO ([FilePath])
liftWriter = WriterT . return . runWriter

readGenomeDir' :: String -> WriterT [String] IO ([FilePath])
readGenomeDir' dir = do
    files <- liftIO $ getDirectoryContents dir
    files2 <- liftWriter $ filterFastaFiles files
    files3 <- liftWriter $ appendGenomeDir dir files2
    return files3
