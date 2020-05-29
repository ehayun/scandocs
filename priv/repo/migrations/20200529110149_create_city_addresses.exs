defmodule Scandoc.Repo.Migrations.CreateCityAddresses do
  use Ecto.Migration

  def change do
    create table(:city_addresses) do
      add :city_id, references(:cities, on_delete: :delete_all), null: false
      add :address_name, :string
      add :address, :string
      add :remarks, :string

      timestamps()
    end
  end
end
