defmodule Scandoc.Tables.District do
  use Ecto.Schema
  import Ecto.Changeset

  schema "districts" do
    field :district_name, :string

    timestamps()
  end

  @doc false
  def changeset(district, attrs) do
    district
    |> cast(attrs, [:district_name])
    |> validate_required([:district_name])
  end
end
