defmodule Scandoc.Tables.City do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cities" do
    field :code, :string
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(city, attrs) do
    city
    |> cast(attrs, [:code, :title])
    |> validate_required([:code, :title])
  end
end
