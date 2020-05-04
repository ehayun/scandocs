defmodule Scandoc.Repo.Migrations.CreateClassrooms do
  use Ecto.Migration

  def change do
    create table(:classrooms) do
      add :code, :string
      add :classroom_name, :string
      add :school_id, references(:schools, on_delete: :nothing), null: false
      add :teacher_id, references(:users, on_delete: :nothing), null: false

      timestamps()
    end
  end
end
