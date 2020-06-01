defmodule Scandoc.Repo.Migrations.AddTransportationToStudents do
  use Ecto.Migration

  def change do
    alter table(:students) do
      add :transportation_id, references(:transportations, on_delete: :nothing), null: true
    end
  end
end
