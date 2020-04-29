defmodule MovieApi.Application do

  use Application
  require Logger

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      # Adding cowboy in the children processes.
      {Plug.Cowboy, scheme: :http, plug: Endpoints, options: [port: port()]},

      # We connect to MongoDB and give the name database
      # The process will be accessible inside the project with the name database
      # instead of its pid.
      worker(Mongo, [[name: :database, database: database(), pool_size: 2]])
    ]

    opts = [strategy: :one_for_one, name: MovieApi.Supervisor]

    Logger.info "The database has been launched..."
    Logger.info "The server has started at port: #{port()}..."

    Supervisor.start_link(children, opts)
  end

  # Getting the port from the config file which represents the environment variables.
  defp port, do: Application.get_env(:movie_api, :port, 8000)

  # Getting the database name from the config file.
  defp database, do: Application.get_env(:movie_api, :database, "movies-api")
end
