defmodule Scandoc.Transportation.Contact do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transportation_contacts" do
    field :contact_name, :string
    field :contact_type, :string
    field :contact_value, :string
    field :remark, :string
    field :transportation_id, :integer

    timestamps()
  end

  @doc false
  def changeset(contact, attrs) do
    contact
    |> cast(attrs, [:transportation_id, :contact_name, :contact_type, :contact_value, :remark])
    |> validate_required([
      :transportation_id,
      :contact_name,
      :contact_type,
      :contact_value,
      :remark
    ])
  end
end
