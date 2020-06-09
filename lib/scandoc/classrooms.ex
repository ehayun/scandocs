defmodule Scandoc.Classrooms do
  @moduledoc """
  The Classrooms context.
  """

  import Ecto.Query, warn: false
  alias Scandoc.Repo

  alias Scandoc.Classrooms.Classroom

  @doc """
  Returns the list of classrooms.

  ## Examples

      iex> list_classrooms()
      [%Classroom{}, ...]

  """
  def list_classrooms(school_id \\ nil) do
    q = Classroom

    q =
      if school_id do
        q |> where(school_id: ^school_id)
      else
        q
      end

    q
    |> preload(:school)
    |> preload(:teacher)
    |> Repo.all()
  end

  @doc """
  Gets a single classroom.

  Raises `Ecto.NoResultsError` if the Classroom does not exist.

  ## Examples

      iex> get_classroom!(123)
      %Classroom{}

      iex> get_classroom!(456)
      ** (Ecto.NoResultsError)

  """
  def get_classroom!(id) do
    IO.inspect(id, label: "get classroom")
    Classroom |> where(id: ^id) |> preload(:school) |> preload(:teacher) |> Repo.one()
    end

  def get_classroom_by_teacher(id) do
    Classroom
    |> where(teacher_id: ^id)
    |> preload(:school)
    |> preload(:teacher)
    |> Repo.all()
    |> Enum.at(0)
  end

  @doc """
  Creates a classroom.

  ## Examples

      iex> create_classroom(%{field: value})
      {:ok, %Classroom{}}

      iex> create_classroom(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_classroom(attrs \\ %{}) do
    %Classroom{}
    |> Classroom.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a classroom.

  ## Examples

      iex> update_classroom(classroom, %{field: new_value})
      {:ok, %Classroom{}}

      iex> update_classroom(classroom, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_classroom(%Classroom{} = classroom, attrs) do
    classroom
    |> Classroom.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a classroom.

  ## Examples

      iex> delete_classroom(classroom)
      {:ok, %Classroom{}}

      iex> delete_classroom(classroom)
      {:error, %Ecto.Changeset{}}

  """
  def delete_classroom(%Classroom{} = classroom) do
    Repo.delete(classroom)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking classroom changes.

  ## Examples

      iex> change_classroom(classroom)
      %Ecto.Changeset{data: %Classroom{}}

  """
  def change_classroom(%Classroom{} = classroom, attrs \\ %{}) do
    Classroom.changeset(classroom, attrs)
  end
end
