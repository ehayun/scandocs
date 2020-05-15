defmodule Scandoc.Repo.Migrations.CreateVendors do
  use Ecto.Migration

  def change do
    create table(:vendors) do
      add :vendor_name, :string
      add :contact_name, :string
      add :address, :string
      add :phone_number, :string
      add :vendor_site, :string

      timestamps()
    end

  end
end
