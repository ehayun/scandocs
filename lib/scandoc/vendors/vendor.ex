defmodule Scandoc.Vendors.Vendor do
  use Ecto.Schema
  import Ecto.Changeset

  schema "vendors" do
    field :address, :string
    field :contact_name, :string
    field :phone_number, :string
    field :vendor_name, :string
    field :vendor_site, :string

    timestamps()
  end

  @doc false
  def changeset(vendor, attrs) do
    vendor
    |> cast(attrs, [:vendor_name, :contact_name, :address, :phone_number, :vendor_site])
    |> validate_required([:vendor_name, :contact_name, :address, :phone_number, :vendor_site])
  end
end
