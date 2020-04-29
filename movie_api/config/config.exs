use Mix.Config

# Importing the configuration depending on the environment.
# If Mix.env() == "dev", we'll have import_config "dev.exs"
import_config "#{Mix.env()}.exs"
