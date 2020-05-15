defmodule Scandoc.Categories do
  @moduledoc """
  The Categories context.
  """

  import Ecto.Query, warn: false
  alias Scandoc.Repo

  alias Scandoc.Categories.Category

  @doc """
  Returns the list of categories.

  ## Examples

      iex> list_categories()
      [%Category{}, ...]

  """
  def list_categories do
    Repo.all(Category)
  end

  @doc """
  Gets a single category.

  Raises `Ecto.NoResultsError` if the Category does not exist.

  ## Examples

      iex> get_category!(123)
      %Category{}

      iex> get_category!(456)
      ** (Ecto.NoResultsError)

  """
  def get_category!(id), do: Repo.get!(Category, id)

  @doc """
  Creates a category.

  ## Examples

      iex> create_category(%{field: value})
      {:ok, %Category{}}

      iex> create_category(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_category(attrs \\ %{}) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a category.

  ## Examples

      iex> update_category(category, %{field: new_value})
      {:ok, %Category{}}

      iex> update_category(category, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_category(%Category{} = category, attrs) do
    category
    |> Category.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a category.

  ## Examples

      iex> delete_category(category)
      {:ok, %Category{}}

      iex> delete_category(category)
      {:error, %Ecto.Changeset{}}

  """
  def delete_category(%Category{} = category) do
    Repo.delete(category)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking category changes.

  ## Examples

      iex> change_category(category)
      %Ecto.Changeset{data: %Category{}}

  """
  def change_category(%Category{} = category, attrs \\ %{}) do
    Category.changeset(category, attrs)
  end

  alias Scandoc.Categories.OutcomeCategory

  @doc """
  Returns the list of outcome_categoryes.

  ## Examples

      iex> list_outcome_categoryes()
      [%OutcomeCategory{}, ...]

  """
  def list_outcome_categoryes do
    Repo.all(OutcomeCategory)
  end

  @doc """
  Gets a single outcome_category.

  Raises `Ecto.NoResultsError` if the Outcome category does not exist.

  ## Examples

      iex> get_outcome_category!(123)
      %OutcomeCategory{}

      iex> get_outcome_category!(456)
      ** (Ecto.NoResultsError)

  """
  def get_outcome_category!(id), do: Repo.get!(OutcomeCategory, id)

  @doc """
  Creates a outcome_category.

  ## Examples

      iex> create_outcome_category(%{field: value})
      {:ok, %OutcomeCategory{}}

      iex> create_outcome_category(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_outcome_category(attrs \\ %{}) do
    %OutcomeCategory{}
    |> OutcomeCategory.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a outcome_category.

  ## Examples

      iex> update_outcome_category(outcome_category, %{field: new_value})
      {:ok, %OutcomeCategory{}}

      iex> update_outcome_category(outcome_category, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_outcome_category(%OutcomeCategory{} = outcome_category, attrs) do
    outcome_category
    |> OutcomeCategory.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a outcome_category.

  ## Examples

      iex> delete_outcome_category(outcome_category)
      {:ok, %OutcomeCategory{}}

      iex> delete_outcome_category(outcome_category)
      {:error, %Ecto.Changeset{}}

  """
  def delete_outcome_category(%OutcomeCategory{} = outcome_category) do
    Repo.delete(outcome_category)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking outcome_category changes.

  ## Examples

      iex> change_outcome_category(outcome_category)
      %Ecto.Changeset{data: %OutcomeCategory{}}

  """
  def change_outcome_category(%OutcomeCategory{} = outcome_category, attrs \\ %{}) do
    OutcomeCategory.changeset(outcome_category, attrs)
  end
end
