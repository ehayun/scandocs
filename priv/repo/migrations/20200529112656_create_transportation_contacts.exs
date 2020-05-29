defmodule Scandoc.Repo.Migrations.CreateTransportationContacts do
  use Ecto.Migration

  def change do
    create table(:transportation_contacts) do
      add :transportation_id, references(:transportations, on_delete: :delete_all), null: false

      add :contact_name, :string
      add :contact_type, :string
      add :contact_value, :string
      add :remark, :string

      timestamps()
    end
  end
end
