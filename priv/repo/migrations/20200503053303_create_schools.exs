defmodule Scandoc.Repo.Migrations.CreateSchools do
  use Ecto.Migration

  def change do
    create table(:schools) do
      add :code, :string, null: false
      add :school_name, :string, null: false
      add :manager_id, references(:users, on_delete: :nothing), null: false

      timestamps()
    end

  end
end
