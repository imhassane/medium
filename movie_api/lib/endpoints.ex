defmodule Endpoints do
  use Plug.Router

  alias Services.MovieService

  plug :match

  # We want the response to be sent in json format.
  plug Plug.Parsers, parsers: [:json], pass: ["application/json"], json_decoder: Jason

  plug :dispatch

  # Getting all the movies.
  get "/all" do
    # We call the service to get all the movies.
    response = MovieService.get_all_movies()
    response |> handle_response(conn)
  end

  # Getting a movie's details given its ID.
  get "/details/:id" do
    response = MovieService.get_one_movie(id)
    response |> handle_response(conn)
  end

  # Adding a new movie.
  post "/new" do
    response = MovieService.add_movie(conn.body_params)
    response |> handle_response(conn)
  end

  # Updating a movie given it's ID.
  put "/edit/:id" do
    response = MovieService.update_one_movie(id, conn.body_params)
    response |> handle_response(conn)
  end

  # Deleting a movie given it's ID.
  delete "/delete/:id" do
    response = MovieService.delete_one_movie(id)
    response |> handle_response(conn)
  end

  match _ do
    send_resp(conn, 404, "Page not found")
  end

  defp handle_response(response, conn) do

    # The service will always return a response that follow this pattern: {:code, :response}.
    # We will use the code to determine whether a request has been successfully treated or not.
    %{code: code, message: message} =
      case response do
        {:ok, message} -> %{code: 200, message: message}
        {:not_found, message} -> %{code: 404, message: message}
        {:malformed_data, message} -> %{code: 400, message: message}
        {:server_error, _} -> %{code: 500, message: "An error occurred internally"}
      end

    conn |> send_resp(code, message)
  end

end