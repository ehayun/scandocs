defmodule Scandoc.Repo.Migrations.CreateCityContacts do
  use Ecto.Migration

  def change do
    create table(:city_contacts) do
      add :city_id, references(:cities, on_delete: :delete_all), null: false
      add :contact_name, :string
      add :contact_type, :string
      add :contact_value, :string
      add :remark, :string

      timestamps()
    end
  end
end
