defmodule Scandoc.Repo.Migrations.CreateStudents do
  use Ecto.Migration

  def change do
    create table(:students) do
      add :student_zehut, :string
      add :full_name, :string
      add :has_picture, :boolean, default: false, null: false
      add :classroom_id, :integer

      timestamps()
    end
  end
end
