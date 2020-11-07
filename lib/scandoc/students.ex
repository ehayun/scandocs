defmodule Scandoc.Students do
  @moduledoc """
  The Students context.
  """

  import Ecto.Query, warn: false
  alias Scandoc.Repo

  alias Scandoc.Students.{Student, StudentComment}
  alias Scandoc.Documents
  alias Scandoc.Documents.Doctype

  @doc """
  Returns the list of students.

  ## Examples

      iex> list_students()
      [%Student{}, ...]

  """
  def list_students do
    Student
    |> preload(:classroom)
    |> preload(:comments)
    |> Repo.all()
  end

  def list_students_in_classroom(classroom_id) do
    Student
    |> where(classroom_id: ^classroom_id)
    |> preload(:classroom)
    |> Repo.all()
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
  def get_student!(id) do
    cc =
      from(
        sc in StudentComment,
        order_by: [
          desc: sc.comment_date
        ]
      )

    from(
      s in Student,
      where: s.id == ^"#{id}",
      preload: [:city],
      preload: [:contacts],
      preload: [:documents],
      preload: [:classroom],
      preload: [
        comments: ^cc
      ]
    )
    |> Repo.one()
  end

  def get_student_by_zehut(id) do
    cc =
      from(
        sc in StudentComment,
        order_by: [
          desc: sc.comment_date
        ]
      )

    from(
      s in Student,
      where: s.student_zehut == ^"#{id}",
      preload: [:city],
      preload: [:classroom],
      preload: [:contacts],
      preload: [
        comments: ^cc
      ]
    )
    |> Repo.one()
  end

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
  def list_stddocs(student_id, filter_by \\ nil, search \\ "") do
    q =
      Stddoc
      |> where(ref_id: ^student_id)
      |> order_by(asc: :doctype_id, asc: :doc_name)

    q =
      if filter_by do
        tmp =
          from(
            dt in Doctype,
            where: dt.doc_group_id == ^filter_by,
            where: ilike(dt.doc_name, ^"%#{search}%")
          )

        tmp =
          tmp
          |> Repo.all()

        dgIds =
          tmp
          |> Enum.map(fn u -> u.id end)

        from(d in q, where: d.doctype_id in ^dgIds)
      else
        tmp =
          from(
            dt in Doctype,
            where: ilike(dt.doc_name, ^"%#{search}%")
          )

        tmp =
          tmp
          |> Repo.all()

        dgIds =
          tmp
          |> Enum.map(fn u -> u.id end)

        from(d in q, where: d.doctype_id in ^dgIds)
      end

    q
    |> order_by(desc: :ref_date)
    |> order_by(desc: :ref_year)
    |> order_by(desc: :ref_month)
    |> preload(:doctype)
    |> Repo.all()
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
  def get_stddoc!(id),
    do:
      Stddoc
      |> where(id: ^id)
      |> preload(:comments)
      |> preload(:doctype)
      |> Repo.one()

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
    #    attrs = Map.merge(attrs, %{doc_name: stddoc.doc_name})
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

  alias Scandoc.Students.StudentComment

  @doc """
  Returns the list of student_comments.

  ## Examples

      iex> list_student_comments()
      [%StudentComment{}, ...]

  """
  def list_student_comments do
    Repo.all(StudentComment)
  end

  @doc """
  Gets a single student_comment.

  Raises `Ecto.NoResultsError` if the Student comment does not exist.

  ## Examples

      iex> get_student_comment!(123)
      %StudentComment{}

      iex> get_student_comment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_student_comment!(id), do: Repo.get!(StudentComment, id)

  @doc """
  Creates a student_comment.

  ## Examples

      iex> create_student_comment(%{field: value})
      {:ok, %StudentComment{}}

      iex> create_student_comment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_student_comment(attrs \\ %{}) do
    %StudentComment{}
    |> StudentComment.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a student_comment.

  ## Examples

      iex> update_student_comment(student_comment, %{field: new_value})
      {:ok, %StudentComment{}}

      iex> update_student_comment(student_comment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_student_comment(%StudentComment{} = student_comment, attrs) do
    student_comment
    |> StudentComment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a student_comment.

  ## Examples

      iex> delete_student_comment(student_comment)
      {:ok, %StudentComment{}}

      iex> delete_student_comment(student_comment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_student_comment(%StudentComment{} = student_comment) do
    Repo.delete(student_comment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking student_comment changes.

  ## Examples

      iex> change_student_comment(student_comment)
      %Ecto.Changeset{data: %StudentComment{}}

  """
  def change_student_comment(%StudentComment{} = student_comment, attrs \\ %{}) do
    StudentComment.changeset(student_comment, attrs)
  end

  alias Scandoc.Students.StudentContact

  @doc """
  Returns the list of student_contacts.

  ## Examples

      iex> list_student_contacts()
      [%StudentContact{}, ...]

  """
  def list_student_contacts do
    Repo.all(StudentContact)
  end

  @doc """
  Gets a single student_contact.

  Raises `Ecto.NoResultsError` if the Student contact does not exist.

  ## Examples

      iex> get_student_contact!(123)
      %StudentContact{}

      iex> get_student_contact!(456)
      ** (Ecto.NoResultsError)

  """
  def get_student_contact!(id), do: Repo.get!(StudentContact, id)

  @doc """
  Creates a student_contact.

  ## Examples

      iex> create_student_contact(%{field: value})
      {:ok, %StudentContact{}}

      iex> create_student_contact(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_student_contact(attrs \\ %{}) do
    %StudentContact{}
    |> StudentContact.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a student_contact.

  ## Examples

      iex> update_student_contact(student_contact, %{field: new_value})
      {:ok, %StudentContact{}}

      iex> update_student_contact(student_contact, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_student_contact(%StudentContact{} = student_contact, attrs) do
    student_contact
    |> StudentContact.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a student_contact.

  ## Examples

      iex> delete_student_contact(student_contact)
      {:ok, %StudentContact{}}

      iex> delete_student_contact(student_contact)
      {:error, %Ecto.Changeset{}}

  """
  def delete_student_contact(%StudentContact{} = student_contact) do
    Repo.delete(student_contact)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking student_contact changes.

  ## Examples

      iex> change_student_contact(student_contact)
      %Ecto.Changeset{data: %StudentContact{}}

  """
  def change_student_contact(%StudentContact{} = student_contact, attrs \\ %{}) do
    StudentContact.changeset(student_contact, attrs)
  end

  def change_student_document(%Stddoc{} = student_document, attrs \\ %{}) do
    Stddoc.changeset(student_document, attrs)
  end
end
