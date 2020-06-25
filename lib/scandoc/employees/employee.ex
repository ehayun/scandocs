defmodule Scandoc.Employees.Employee do
  use Ecto.Schema
  import Ecto.Changeset

  alias Scandoc.Permissions.Permission

  schema "users" do
    field :date_of_birth, :date
    field :full_name, :string
    field :hashed_password, :string
    field :password, :string, virtual: true
    field :is_admin, :boolean, default: false
    field :is_freezed, :boolean, default: false
    field :role, :string, default: "030"
    field :school_id, :integer, virtual: true
    field :classroom_id, :integer, virtual: true
    field :zehut, :string, unique: true

    has_many :permissions, Permission, foreign_key: :user_id

    timestamps()
  end

  @doc false
  def changeset(employee, attrs) do
    employee
    |> cast(
      attrs,
      [
        :zehut,
        :hashed_password,
        :full_name,
        :role,
        :date_of_birth,
        :is_freezed,
        :is_admin
      ]
    )
    |> validate_required([:zehut, :hashed_password, :full_name, :role, :date_of_birth])
    |> cast_assoc(:permissions)
    |> unique_constraint(:zehut)
  end
end
