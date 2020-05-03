defmodule Scandoc.Schools.School do
  use Ecto.Schema
  import Ecto.Changeset

  alias Scandoc.Schools.Manager

  schema "schools" do
    field :code, :string
    belongs_to :manager, Manager, references: :id
    field :school_name, :string

    timestamps()
  end

  @doc false
  def changeset(school, attrs) do
    school
    |> cast(attrs, [:code, :school_name, :manager_id])
    |> validate_required([:code, :school_name, :manager_id])
  end
end
