defmodule Scandoc.City.CityContact do
  use Ecto.Schema
  import Ecto.Changeset

  alias Scandoc.Tables.City

  schema "city_contacts" do
    field :contact_name, :string
    field :contact_type, :string
    field :contact_value, :string
    field :remark, :string
    belongs_to :city, City, references: :id
    field :temp_id, :string, virtual: true
    field :delete, :boolean, virtual: true, default: false

    timestamps()
  end

  @doc false
  def changeset(contact, attrs) do
    contact
    |> cast(attrs, [:city_id, :contact_name, :contact_type, :contact_value, :remark, :delete])
    |> validate_required([:city_id, :contact_name, :contact_type, :contact_value])
    |> maybe_mark_for_deletion()
  end
  defp maybe_mark_for_deletion(
         %{
           data: %{
             id: nil
           }
         } = changeset
       ), do: changeset

  defp maybe_mark_for_deletion(changeset) do
    if get_change(changeset, :delete) do
      %{changeset | action: :delete}
    else
      changeset
    end
  end
end
