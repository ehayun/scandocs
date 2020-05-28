defmodule Scandoc.Tables do
  @moduledoc """
  The Tables context.
  """

  import Ecto.Query, warn: false
  alias Scandoc.Repo

  alias Scandoc.Tables.City

  def list_healthcare do
    [
      %{name: ""},
      %{name: "כללית"},
      %{name: "לאומית"},
      %{name: "מכבי"},
      %{name: "מאוחדת"}
    ]
  end

  def list_gender do
    [
      %{code: "", title: ""},
      %{code: nil, title: ""},
      %{code: "1", title: "זכר"},
      %{code: "2", title: "נקבה"}
    ]
  end

  def list_contact_types do
    [
      %{code: "", title: "טל. נייד"},
      %{code: "", title: "טל. קווי"},
      %{code: "", title: "אימייל"},
      %{code: "", title: "פקס"}
    ]
  end

  @doc """
  Returns the list of cities.

  ## Examples

      iex> list_cities()
      [%City{}, ...]

  """
  def list_cities(limit \\ 10000) do
    City |> order_by(:title) |> Repo.paginate(page_size: limit)
  end

  @doc """
  Gets a single city.

  Raises `Ecto.NoResultsError` if the City does not exist.

  ## Examples

      iex> get_city!(123)
      %City{}

      iex> get_city!(456)
      ** (Ecto.NoResultsError)

  """
  def get_city!(id), do: Repo.get!(City, id)

  @doc """
  Creates a city.

  ## Examples

      iex> create_city(%{field: value})
      {:ok, %City{}}

      iex> create_city(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_city(attrs \\ %{}) do
    %City{}
    |> City.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a city.

  ## Examples

      iex> update_city(city, %{field: new_value})
      {:ok, %City{}}

      iex> update_city(city, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_city(%City{} = city, attrs) do
    city
    |> City.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a city.

  ## Examples

      iex> delete_city(city)
      {:ok, %City{}}

      iex> delete_city(city)
      {:error, %Ecto.Changeset{}}

  """
  def delete_city(%City{} = city) do
    Repo.delete(city)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking city changes.

  ## Examples

      iex> change_city(city)
      %Ecto.Changeset{data: %City{}}

  """
  def change_city(%City{} = city, attrs \\ %{}) do
    City.changeset(city, attrs)
  end
end
