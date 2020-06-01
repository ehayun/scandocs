defmodule Scandoc.Tables.City do
  use Ecto.Schema
  import Ecto.Changeset

  alias Scandoc.Tables.District

  schema "cities" do
    field :code, :string
    field :title, :string
    belongs_to :district, District, references: :id
    timestamps()
  end

  @doc false
  def changeset(city, attrs) do
    city
    |> cast(attrs, [:code, :title, :district_id])
    |> validate_required([:code, :title, :district_id])
  end
end
