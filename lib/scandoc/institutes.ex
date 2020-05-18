defmodule Scandoc.Institutes do
  @moduledoc """
  The Institutes context.
  """

  import Ecto.Query, warn: false
  alias Scandoc.Repo

  alias Scandoc.Institutes.Institute

  @doc """
  Returns the list of institutes.

  ## Examples

      iex> list_institutes()
      [%Institute{}, ...]

  """
  def list_institutes do
    Institute |> order_by(:title) |> Repo.all()
  end

  @doc """
  Gets a single institute.

  Raises `Ecto.NoResultsError` if the Institute does not exist.

  ## Examples

      iex> get_institute!(123)
      %Institute{}

      iex> get_institute!(456)
      ** (Ecto.NoResultsError)

  """
  def get_institute!(id), do: Repo.get!(Institute, id)

  @doc """
  Creates a institute.

  ## Examples

      iex> create_institute(%{field: value})
      {:ok, %Institute{}}

      iex> create_institute(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_institute(attrs \\ %{}) do
    %Institute{}
    |> Institute.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a institute.

  ## Examples

      iex> update_institute(institute, %{field: new_value})
      {:ok, %Institute{}}

      iex> update_institute(institute, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_institute(%Institute{} = institute, attrs) do
    institute
    |> Institute.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a institute.

  ## Examples

      iex> delete_institute(institute)
      {:ok, %Institute{}}

      iex> delete_institute(institute)
      {:error, %Ecto.Changeset{}}

  """
  def delete_institute(%Institute{} = institute) do
    Repo.delete(institute)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking institute changes.

  ## Examples

      iex> change_institute(institute)
      %Ecto.Changeset{data: %Institute{}}

  """
  def change_institute(%Institute{} = institute, attrs \\ %{}) do
    Institute.changeset(institute, attrs)
  end

  alias Scandoc.Institutes.Instdoc

  @doc """
  Returns the list of inst_docs.

  ## Examples

      iex> list_inst_docs()
      [%Instdoc{}, ...]

  """
  def list_inst_docs(
        limit \\ 0,
        filter \\ filter = %{
          "category" => "-1",
          "institute" => "-1",
          "outcome_category" => "-1",
          "vendor_name" => ""
        }
      ) do
    %{
      "category" => category_id,
      "institute" => institute_id,
      "outcome_category" => outcome_category_id,
      "vendor_name" => vendor_name
    } = filter

    q = from(i in Instdoc, where: ilike(i.vendor_name, ^"%#{vendor_name}%"))

    q =
      if limit > 0 do
        q |> limit(^limit)
      else
        q
      end

    q
    |> preload(:institute)
    |> preload(:category)
    |> preload(:outcome_category)
    |> order_by(desc: :doc_date)
    |> Repo.all()
  end

  @doc """
  Gets a single instdoc.

  Raises `Ecto.NoResultsError` if the Instdoc does not exist.

  ## Examples

      iex> get_instdoc!(123)
      %Instdoc{}

      iex> get_instdoc!(456)
      ** (Ecto.NoResultsError)

  """
  def get_instdoc!(id), do: Repo.get!(Instdoc, id)

  @doc """
  Creates a instdoc.

  ## Examples

      iex> create_instdoc(%{field: value})
      {:ok, %Instdoc{}}

      iex> create_instdoc(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_instdoc(attrs \\ %{}) do
    %Instdoc{}
    |> Instdoc.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a instdoc.

  ## Examples

      iex> update_instdoc(instdoc, %{field: new_value})
      {:ok, %Instdoc{}}

      iex> update_instdoc(instdoc, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_instdoc(%Instdoc{} = instdoc, attrs) do
    instdoc
    |> Instdoc.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a instdoc.

  ## Examples

      iex> delete_instdoc(instdoc)
      {:ok, %Instdoc{}}

      iex> delete_instdoc(instdoc)
      {:error, %Ecto.Changeset{}}

  """
  def delete_instdoc(%Instdoc{} = instdoc) do
    Repo.delete(instdoc)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking instdoc changes.

  ## Examples

      iex> change_instdoc(instdoc)
      %Ecto.Changeset{data: %Instdoc{}}

  """
  def change_instdoc(%Instdoc{} = instdoc, attrs \\ %{}) do
    Instdoc.changeset(instdoc, attrs)
  end
end
