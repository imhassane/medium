defmodule EndpointTest do
  use ExUnit.Case
  use Plug.Test

  alias Endpoints

  @options Endpoints.init([])

  test "Fetching all movies" do
    conn =
      :get
      |> conn("/all", "")
      |> Endpoints.call(@options)

    assert conn.state == :sent
    assert conn.status == 200
  end

  test "Fetching an existing movie" do
    # Make sure the movie exists.
    conn =
      :get
      |> conn("/details/5ea8e90dce328217581f0948", "")
      |> Endpoints.call(@options)

    assert conn.state == :sent
    assert conn.status == 200
  end

  test "Fetching with a false id" do
    conn =
      :get
      |> conn("/details/id", "")
      |> Endpoints.call(@options)

    assert conn.state == :sent
    assert conn.status == 404
  end

  test "Calling a non existing endpoint" do
    conn =
      :get
      |> conn("/non-existing", "")
      |> Endpoints.call(@options)

    assert conn.state == :sent
    assert conn.status == 404
  end
end