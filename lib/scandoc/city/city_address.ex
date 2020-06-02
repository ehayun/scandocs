defmodule Scandoc.City.CityAddress do
  use Ecto.Schema
  import Ecto.Changeset

  alias Scandoc.Tables.City

  schema "city_addresses" do
    belongs_to :city, City, references: :id
    field :address, :string
    field :address_name, :string
    field :remarks, :string
    field :temp_id, :string, virtual: true
    field :delete, :boolean, virtual: true, default: false

    timestamps()
  end

  @doc false
  def changeset(address, attrs) do
    address
    |> cast(attrs, [:city_id, :address_name, :address, :remarks])
    |> validate_required([:city_id, :address_name, :address, :remarks])
    |> maybe_mark_for_deletion()
  end

  defp maybe_mark_for_deletion(
         %{
           data: %{
             id: nil
           }
         } = changeset
       ),
       do: changeset

  defp maybe_mark_for_deletion(changeset) do
    if get_change(changeset, :delete) do
      %{changeset | action: :delete}
    else
      changeset
    end
  end
end
