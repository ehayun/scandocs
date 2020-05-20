defmodule Scandoc.Employees.Employee do
  use Ecto.Schema
  import Ecto.Changeset

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
    field :zehut, :string

    timestamps()
  end

  @doc false
  def changeset(employee, attrs) do
    employee
    |> cast(attrs, [
      :zehut,
      :hashed_password,
      :full_name,
      :role,
      :date_of_birth,
      :is_freezed,
      :is_admin
    ])
    |> validate_required([:zehut, :hashed_password, :full_name, :role, :date_of_birth])
  end
end
