module CommandLine where
import Options.Applicative


data Params = Params
              {
                genome_path :: String,
                bowtie_path :: String
              }

parser = Params
  <$> strOption (long "genome" <>
                 short 'g' <>
                 metavar "GENOME_DIR" <>
                 help "Path to the directory with fasta chromosome files")
  <*> strOption (long "bowtie" <>
                 short 'b' <>
                 metavar "BOWTIE_path" <>
                 help "Path to the bowtie executable")

params = info (helper <*> parser)
  (fullDesc <>
   progDesc "In-silico bisulfie conversion of genome sequences, compatible with Bismark genome preparation")

showHelpOnErrorExecParser :: ParserInfo a -> IO a
showHelpOnErrorExecParser = customExecParser (prefs showHelpOnError)

              
