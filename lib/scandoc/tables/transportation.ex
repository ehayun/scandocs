defmodule Scandoc.Tables.Transportation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transportations" do
    field :company_address, :string
    field :company_name, :string
    field :remarks, :string

    timestamps()
  end

  @doc false
  def changeset(transportation, attrs) do
    transportation
    |> cast(attrs, [:company_name, :company_address, :remarks])
    |> validate_required([:company_name, :company_address, :remarks])
  end
end
