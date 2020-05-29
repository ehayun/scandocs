defmodule Scandoc.City.Address do
  use Ecto.Schema
  import Ecto.Changeset

  schema "city_addresses" do
    field :city_id, :integer
    field :address, :string
    field :address_name, :string
    field :remarks, :string

    timestamps()
  end

  @doc false
  def changeset(address, attrs) do
    address
    |> cast(attrs, [:city_id, :address_name, :address, :remarks])
    |> validate_required([:city_id, :address_name, :address, :remarks])
  end
end
