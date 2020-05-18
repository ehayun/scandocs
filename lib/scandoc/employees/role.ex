defmodule Scandoc.Employees.Role do
  use Ecto.Schema
  import Ecto.Changeset

  schema "roles" do
    field :code, :string
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(role, attrs) do
    role
    |> cast(attrs, [:code, :title])
    |> validate_required([:code, :title])
  end
end
