defmodule Scandoc.Permissions do
  @moduledoc """
  The Permissions context.
  """

  import Ecto.Query, warn: false
  alias Scandoc.Repo

  alias Scandoc.Permissions.Permission
  # alias Scandoc.Schools
  alias Scandoc.Schools.School
  # alias Scandoc.Classrooms
  alias Scandoc.Classrooms.Classroom
  alias Scandoc.Accounts.User

  @doc """
  Returns the list of permissions.

  ## Examples

      iex> list_permissions()
      [%Permission{}, ...]

  """
  def list_permissions do
    Repo.all(Permission)
  end

  @doc """
  Gets a single permission.

  Raises `Ecto.NoResultsError` if the Permission does not exist.

  ## Examples

      iex> get_permission!(123)
      %Permission{}

      iex> get_permission!(456)
      ** (Ecto.NoResultsError)

  """
  def get_permission!(id) do
    perm = Repo.get!(Permission, id)
    p = getPermType(perm.permission_type)
    perm = perm |> Map.merge(%{permmission_level: p})

    perm =
      if perm.permmission_level == :allow_classroom,
        do: Map.merge(perm, %{classroom_id: perm.ref_id}),
        else: perm

    perm =
      if perm.permmission_level == :allow_school,
        do: Map.merge(perm, %{school_id: perm.ref_id}),
        else: perm

    perm =
      if perm.permmission_level == :allow_student,
        do: Map.merge(perm, %{student_id: perm.ref_id}),
        else: perm

    perm =
      if perm.permmission_level == :allow_institute,
        do: Map.merge(perm, %{institute_id: perm.ref_id}),
        else: perm

    perm =
      if perm.permmission_level == :allow_vendor,
        do: Map.merge(perm, %{vendor_name: perm.ref_id}),
        else: perm

    if perm.permmission_level == :allow_classroom do
      # is class, get school id
      case Classroom |> where(id: ^perm.ref_id) |> Repo.one() do
        nil ->
          perm

        classroom ->
          case School |> where(id: ^classroom.school_id) |> Repo.one() do
            nil ->
              perm

            s ->
              Map.merge(perm, %{school_id: s.id})
          end
      end
    else
      perm
    end
  end

  @doc """
  Creates a permission.

  ## Examples

      iex> create_permission(%{field: value})
      {:ok, %Permission{}}

      iex> create_permission(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_permission(attrs \\ %{}) do
    %Permission{}
    |> Permission.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a permission.

  ## Examples

      iex> update_permission(permission, %{field: new_value})
      {:ok, %Permission{}}

      iex> update_permission(permission, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_permission(%Permission{} = permission, attrs) do
    permission
    |> Permission.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a permission.

  ## Examples

      iex> delete_permission(permission)
      {:ok, %Permission{}}

      iex> delete_permission(permission)
      {:error, %Ecto.Changeset{}}

  """
  def delete_permission(%Permission{} = permission) do
    Repo.delete(permission)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking permission changes.

  ## Examples

      iex> change_permission(permission)
      %Ecto.Changeset{data: %Permission{}}

  """
  def change_permission(%Permission{} = permission, attrs \\ %{}) do
    Permission.changeset(permission, attrs)
  end

  def isAdmin(nil), do: false

  def isAdmin(%User{} = user) do
    if isAdmin(user.id) do
      true
    else
      user.is_admin || user.role == "000"
    end
  end

  def isAdmin(user_id) do
    p =
      Permission
      |> where(user_id: ^user_id)
      |> where(permission_type: 0)
      |> Repo.aggregate(:count)

    p > 0
  end

  defp getIds(type, user_id) do
    aType = type
    type = getLevelToInt(type)

    list =
      Permission
      |> where(user_id: ^user_id)
      |> where(permission_type: ^type)
      |> Repo.all()
      |> Enum.map(fn u -> u.ref_id end)

    ndList =
      case aType do
        :allow_school ->
          School |> where(manager_id: ^user_id) |> Repo.all() |> Enum.map(fn u -> u.id end)

        :allow_classroom ->
          Classroom |> where(teacher_id: ^user_id) |> Repo.all() |> Enum.map(fn u -> u.id end)

        :allow_student ->
          []

        _ ->
          []
      end

    Enum.uniq(list ++ ndList)
  end

  def getSchools(user_id), do: getIds(:allow_school, user_id)
  def getClassrooms(user_id), do: getIds(:allow_classroom, user_id)
  def getStudents(user_id), do: getIds(:allow_student, user_id)
  def getInstitutes(user_id), do: getIds(:allow_institute, user_id)
  def getVendors(user_id), do: getIds(:allow_vendor, user_id)

  def getLevelToInt(a) do
    case a do
      :allow_all -> 0
      :allow_school -> 1
      :allow_classroom -> 2
      :allow_student -> 3
      :allow_institute -> 4
      :allow_vendor -> 5
    end
  end

  def getPermType(t) do
    case t do
      0 -> :allow_all
      1 -> :allow_school
      2 -> :allow_classroom
      3 -> :allow_student
      4 -> :allow_institute
      5 -> :allow_vendor
      _ -> :unknown
    end
  end

  def getLevelToString(l) do
    case l do
      0 -> "ללא הגבלה"
      1 -> "הרשאת בית ספר"
      2 -> "הרשאת כיתה"
      3 -> "הרשאת תלמיד"
      4 -> "הרשאת מוסד"
      5 -> "הרשאת ספק"
      _ -> "לא ידוע"
    end
  end

  # EOF
end
