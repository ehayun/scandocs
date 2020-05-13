defmodule Scandoc.Students do
  @moduledoc """
  The Students context.
  """

  import Ecto.Query, warn: false
  alias Scandoc.Repo

  alias Scandoc.Students.Student
  alias Scandoc.Documents.Doctype

  @doc """
  Returns the list of students.

  ## Examples

      iex> list_students()
      [%Student{}, ...]

  """
  def list_students do
    Student |> preload(:classroom) |> Repo.all()
  end

  @doc """
  Gets a single student.

  Raises `Ecto.NoResultsError` if the Student does not exist.

  ## Examples

      iex> get_student!(123)
      %Student{}

      iex> get_student!(456)
      ** (Ecto.NoResultsError)

  """
  def get_student!(id), do: Repo.get!(Student, id)

  @doc """
  Creates a student.

  ## Examples

      iex> create_student(%{field: value})
      {:ok, %Student{}}

      iex> create_student(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_student(attrs \\ %{}) do
    %Student{}
    |> Student.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a student.

  ## Examples

      iex> update_student(student, %{field: new_value})
      {:ok, %Student{}}

      iex> update_student(student, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_student(%Student{} = student, attrs) do
    student
    |> Student.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a student.

  ## Examples

      iex> delete_student(student)
      {:ok, %Student{}}

      iex> delete_student(student)
      {:error, %Ecto.Changeset{}}

  """
  def delete_student(%Student{} = student) do
    Repo.delete(student)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking student changes.

  ## Examples

      iex> change_student(student)
      %Ecto.Changeset{data: %Student{}}

  """
  def change_student(%Student{} = student, attrs \\ %{}) do
    Student.changeset(student, attrs)
  end

  alias Scandoc.Students.Stddoc

  @doc """
  Returns the list of stddocs.

  ## Examples

      iex> list_stddocs()
      [%Stddoc{}, ...]

  """
  def list_stddocs(student_id, filter_by \\ nil) do
    q = Stddoc |> where(ref_id: ^student_id)

    q =
      if filter_by do
        tmp = Doctype |> where(doc_group_id: ^filter_by) |> Repo.all()
        dgIds = tmp |> Enum.map(fn u -> u.id end)
        from(d in q, where: d.doctype_id in ^dgIds)
      else
        q
      end

    q |> preload(:doctype) |> Repo.all()
  end

  @doc """
  Gets a single stddoc.

  Raises `Ecto.NoResultsError` if the Stddoc does not exist.

  ## Examples

      iex> get_stddoc!(123)
      %Stddoc{}

      iex> get_stddoc!(456)
      ** (Ecto.NoResultsError)

  """
  def get_stddoc!(id), do: Stddoc |> where(id: ^id) |> preload(:doctype) |> Repo.one()

  @doc """
  Creates a stddoc.

  ## Examples

      iex> create_stddoc(%{field: value})
      {:ok, %Stddoc{}}

      iex> create_stddoc(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_stddoc(attrs \\ %{}) do
    %Stddoc{}
    |> Stddoc.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a stddoc.

  ## Examples

      iex> update_stddoc(stddoc, %{field: new_value})
      {:ok, %Stddoc{}}

      iex> update_stddoc(stddoc, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_stddoc(%Stddoc{} = stddoc, attrs) do
    stddoc
    |> Stddoc.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a stddoc.

  ## Examples

      iex> delete_stddoc(stddoc)
      {:ok, %Stddoc{}}

      iex> delete_stddoc(stddoc)
      {:error, %Ecto.Changeset{}}

  """
  def delete_stddoc(%Stddoc{} = stddoc) do
    Repo.delete(stddoc)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking stddoc changes.

  ## Examples

      iex> change_stddoc(stddoc)
      %Ecto.Changeset{data: %Stddoc{}}

  """
  def change_stddoc(%Stddoc{} = stddoc, attrs \\ %{}) do
    Stddoc.changeset(stddoc, attrs)
  end
end
