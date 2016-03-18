import Control.Monad.Trans.Maybe
import CommandLine
import ReadFiles

run :: Params -> IO ()
run params = do
  readFiles $ genome_path params  
  return ()

main :: IO ()
main = showHelpOnErrorExecParser params >>= run
