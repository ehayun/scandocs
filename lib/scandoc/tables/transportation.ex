defmodule Scandoc.Tables.Transportation do
  use Ecto.Schema
  import Ecto.Changeset
  alias Scandoc.Transportation.TransportationContact

  schema "transportations" do
    field :company_address, :string
    field :company_name, :string
    field :remarks, :string
    has_many :contacts, TransportationContact, references: :id
    timestamps()
  end

  @doc false
  def changeset(transportation, attrs) do
    transportation
    |> cast(attrs, [:company_name, :company_address, :remarks])
    |> validate_required([:company_name])
    |> cast_assoc(:contacts)
  end
end
