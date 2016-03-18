module ReadFiles where
import Control.Monad.Identity
import System.Directory
import System.FilePath.Posix
import Control.Monad.Trans.Maybe
import Control.Monad.Writer
import Debug.Trace

-- type IMWriter a = (WriterT [String]) (MaybeT IO) a
type FastaReaderT a = MaybeT (WriterT [String] IO) a

liftMaybe :: Maybe a -> FastaReaderT a
liftMaybe a = (MaybeT . lift . return) a

-- append dir path to fasta files, so there is a full path
appendGenomeDir :: String -> [FilePath] -> [FilePath]
appendGenomeDir dir files = appendedFiles
  where
    appendedFiles = map (\file -> joinPath [dir, file]) files
      
filterFastaFiles :: [FilePath] -> Maybe [FilePath]
filterFastaFiles files
  | filtered == [] = Nothing
  | otherwise = Just filtered
  where 
    filtered = take 3 [file | file <- files, takeExtension file == ".fa"]

readGenomeDir :: String -> FastaReaderT [FilePath]
readGenomeDir dir = do
  tell ["Reading files"]
  allFiles <- liftIO $ getDirectoryContents dir
  tell ["Selecting fasta files"]
  fastaFiles <- liftMaybe $ filterFastaFiles allFiles
  tell ["Appending genome dir"]
  return $ appendGenomeDir dir fastaFiles  

-- for testing purposes this function retuns IO() but it will change
readFiles :: String -> IO ()
readFiles dir = do
  res <- runWriterT $ runMaybeT $ readGenomeDir dir
  putStrLn "Files:"
  putStrLn $ show $ fmap (\xs -> take 3 xs) (fst res)
  putStrLn "Log:"
  putStrLn $ show $ snd res
  return ()

liftWriter :: Writer [String] [FilePath] -> WriterT [String] IO ([FilePath])
liftWriter = WriterT . return . runWriter
