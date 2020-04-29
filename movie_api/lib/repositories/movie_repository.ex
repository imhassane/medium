defmodule Repository.MovieRepository do

  # The will represent our document's name.
  @collection "movies"

  def list() do
    :database |> Mongo.find(@collection, %{})
  end

  def get(id) do
    :database |> Mongo.find_one(@collection, %{"_id" => id})
  end

  def add(data) do
    :database |> Mongo.insert_one(@collection, data)
  end

  def update(id, data) do
    :database |> Mongo.find_one_and_update(@collection, %{"_id" => id}, %{"$set": data})
  end

  def delete(id) do
    :database |> Mongo.find_one_and_delete(@collection, %{"_id" => id})
  end

end