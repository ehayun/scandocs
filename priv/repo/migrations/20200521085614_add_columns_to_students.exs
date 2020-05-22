defmodule Scandoc.Repo.Migrations.AddColumnsToStudents do
  use Ecto.Migration

  def change do
    alter table(:students) do
      add :last_name, :string
      add :first_name, :string
      add :birthdate, :date
      add :hebrew_birthdate, :string
      add :gender, :string
      add :address, :string
      add :healthcare, :string
      add :city_id, :integer
      add :sending_authority_id, :integer
      add :father_name, :string
      add :mother_name, :string
      add :father_zehut, :string
      add :mother_zehut, :string
    end

    create unique_index(:students, [:student_zehut])
  end
end
