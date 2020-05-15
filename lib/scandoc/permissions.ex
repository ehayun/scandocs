defmodule Scandoc.Permissions do
  @moduledoc """
  The Permissions context.
  """

  import Ecto.Query, warn: false
  alias Scandoc.Repo

  alias Scandoc.Permissions.Permission
  alias Scandoc.Schools.School
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

    if perm.permission_type == 2 do
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
    Permission
    |> where(user_id: ^user_id)
    |> where(permission_type: ^type)
    |> Repo.all()
    |> Enum.map(fn u -> u.ref_id end)
  end

  def getSchools(user_id), do: getIds(1, user_id)
  def getClassrooms(user_id), do: getIds(2, user_id)
  def getStudents(user_id), do: getIds(3, user_id)

  # EOF
end
