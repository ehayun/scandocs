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
      %{code: "mobile", title: "טל. נייד"},
      %{code: "phone", title: "טל. קווי"},
      %{code: "email", title: "אימייל"},
      %{code: "fax", title: "פקס"}
    ]
  end

  @doc """
  Returns the list of cities.

  ## Examples

      iex> list_cities()
      [%City{}, ...]

  """
  def list_cities(limit \\ 10000, page \\ 1, search \\ "") do
    cq = from(c in City, where: ilike(c.title, ^"%#{search}%"), order_by: :title)

    cq
    |> preload(:district)
    |> Repo.paginate(page: page, page_size: limit)
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

  alias Scandoc.Tables.District

  @doc """
  Returns the list of districts.

  ## Examples

      iex> list_districts()
      [%District{}, ...]

  """
  def list_districts() do
    District
    |> order_by(:district_name)
    |> Repo.all()
  end

  @doc """
  Gets a single district.

  Raises `Ecto.NoResultsError` if the District does not exist.

  ## Examples

      iex> get_district!(123)
      %District{}

      iex> get_district!(456)
      ** (Ecto.NoResultsError)

  """
  def get_district!(id), do: Repo.get!(District, id)

  @doc """
  Creates a district.

  ## Examples

      iex> create_district(%{field: value})
      {:ok, %District{}}

      iex> create_district(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_district(attrs \\ %{}) do
    %District{}
    |> District.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a district.

  ## Examples

      iex> update_district(district, %{field: new_value})
      {:ok, %District{}}

      iex> update_district(district, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_district(%District{} = district, attrs) do
    district
    |> District.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a district.

  ## Examples

      iex> delete_district(district)
      {:ok, %District{}}

      iex> delete_district(district)
      {:error, %Ecto.Changeset{}}

  """
  def delete_district(%District{} = district) do
    Repo.delete(district)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking district changes.

  ## Examples

      iex> change_district(district)
      %Ecto.Changeset{data: %District{}}

  """
  def change_district(%District{} = district, attrs \\ %{}) do
    District.changeset(district, attrs)
  end

  alias Scandoc.Tables.Transportation

  @doc """
  Returns the list of transportations.

  ## Examples

      iex> list_transportations()
      [%Transportation{}, ...]

  """
  def list_transportations(limit \\ 15) do
    Transportation
    |> order_by(:company_name)
    |> Repo.paginate(page_size: limit)
  end

  def list_all_transportations() do
    Transportation |> order_by(:company_name) |> Repo.all()
  end

  @doc """
  Gets a single transportation.

  Raises `Ecto.NoResultsError` if the Transportation does not exist.

  ## Examples

      iex> get_transportation!(123)
      %Transportation{}

      iex> get_transportation!(456)
      ** (Ecto.NoResultsError)

  """
  def get_transportation!(id),
    do: Transportation |> where(id: ^id) |> preload(:contacts) |> Repo.one()

  @doc """
  Creates a transportation.

  ## Examples

      iex> create_transportation(%{field: value})
      {:ok, %Transportation{}}

      iex> create_transportation(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_transportation(attrs \\ %{}) do
    %Transportation{}
    |> Transportation.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a transportation.

  ## Examples

      iex> update_transportation(transportation, %{field: new_value})
      {:ok, %Transportation{}}

      iex> update_transportation(transportation, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_transportation(%Transportation{} = transportation, attrs) do
    transportation
    |> Transportation.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a transportation.

  ## Examples

      iex> delete_transportation(transportation)
      {:ok, %Transportation{}}

      iex> delete_transportation(transportation)
      {:error, %Ecto.Changeset{}}

  """
  def delete_transportation(%Transportation{} = transportation) do
    Repo.delete(transportation)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking transportation changes.

  ## Examples

      iex> change_transportation(transportation)
      %Ecto.Changeset{data: %Transportation{}}

  """
  def change_transportation(%Transportation{} = transportation, attrs \\ %{}) do
    Transportation.changeset(transportation, attrs)
  end

  alias Scandoc.Transportation.TransportationContact

  def change_transportation_contact(%TransportationContact{} = transportation, attrs \\ %{}) do
    TransportationContact.changeset(transportation, attrs)
  end
end
