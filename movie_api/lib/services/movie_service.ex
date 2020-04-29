defmodule Services.MovieService do

  alias Repository.MovieRepository

  # Getting all the movies.
  def get_all_movies() do
    movies = MovieRepository.list()
    # We transform the movies to a list.
    movies = movies
             |> Enum.map(fn (%{"_id" => id} = m) ->
                              # Transforming the BSON ObjectId to string (binary)
                              id = BSON.ObjectId.encode!(id)

                              # Encoding the map to json.
                              Jason.encode!(%{ m | "_id" => id })
                         end)

    {:ok, movies}
  end

  # Getting a movie by it's ID.
  def get_one_movie(id) when is_binary(id) do
    # If the id is not a valid object id, it will raise an error.
    try do
      # Converting the id to BSON.ObjectID
      object_id = BSON.ObjectId.decode!(id)

      # Fetching the movie
      movie = MovieRepository.get(object_id)

      # Converting the bson object_id to binary object_id and returning json.
      movie = %{ movie | "_id" => id } |> Jason.encode!
      {:ok, movie}
    rescue
      _ in FunctionClauseError -> {:not_found, "The movie does not exist"}
      _ -> {:server_error, "An error occurred internally"}
    end
  end

  def get_one_movie(_), do: {:not_found, "The movie does not exist"}

  # Adding a movie.
  def add_movie(%{"name" => _name, "description" => _description, "cast" => _cast} = data) do
    MovieRepository.add(data)
    {:ok, "The movie has been added successfully"}
  end

  def add_movie(_), do: {:malformed_data, "Cannot add the movie: please enter the correct values"}

  # Updating the movie.
  def update_one_movie(id, data) when is_binary(id) do
    try do
      # Converting the id to a valid bson object_id
      object_id = BSON.ObjectId.decode!(id)

      # updating the movie.
      {:ok, movie} = MovieRepository.update(object_id, data)

      # converting the object to a string value and to json.
      movie = %{ movie | "_id" => id } |> Jason.encode!

      {:ok, movie}
    rescue
        _ in FunctionClauseError -> {:not_found, "The movie does not exist"}
        _ -> {:server_error, ""}
    end
  end

  def update_one_movie(_, _), do: {:not_found, "The movie does not exist"}

  # Deleting the movie.
  def delete_one_movie(id) when is_binary(id) do
    try do
      # Converting the id to a valid object id
      object_id = BSON.ObjectId.decode!(id)

      # deleting the movie.
      {:ok, movie} = MovieRepository.delete(object_id)

      # converting the movie to json
      movie = %{ movie | "_id" => id } |> Jason.encode!
      {:ok, movie}
    rescue
        _ in FunctionClauseError -> {:not_found, "The movie does not exist"}
        _ -> {:server_error, ""}
    end
  end

  def delete_one_movie(_), do: {:not_found, "The movie does not exist"}
end