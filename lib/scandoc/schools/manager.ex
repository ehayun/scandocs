defmodule Scandoc.Schools.Manager do
  use Ecto.Schema
  import Ecto.Changeset
  alias Scandoc.Schools.School

  schema "users" do
    field :full_name, :string
    field :zehut, :string
    field :role, :string, default: "020"
    field :date_of_birth, :date
    has_one :school, School

    timestamps()
  end

  @doc false
  def changeset(manager, attrs) do
    manager
    |> cast(attrs, [:zehut, :full_name, :date_of_birth])
    |> validate_required([:zehut, :full_name])
  end
end
