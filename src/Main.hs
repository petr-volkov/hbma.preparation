import Options.Applicative
import Data.Monoid
import CommandLine

run :: Params -> IO ()
run _ = putStrLn ("Not yet implemented")

main :: IO ()
main = showHelpOnErrorExecParser params >>= run
