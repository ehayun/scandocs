defmodule Scandoc.City.Contact do
  use Ecto.Schema
  import Ecto.Changeset

  schema "city_contacts" do
    field :city_id, :integer
    field :contact_name, :string
    field :contact_type, :string
    field :contact_value, :string
    field :remark, :string

    timestamps()
  end

  @doc false
  def changeset(contact, attrs) do
    contact
    |> cast(attrs, [:city_id, :contact_name, :contact_type, :contact_value, :remark])
    |> validate_required([:city_id, :contact_name, :contact_type, :contact_value, :remark])
  end
end
