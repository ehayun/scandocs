defmodule Scandoc.Repo.Migrations.CreateStudentComments do
  use Ecto.Migration

  def change do
    create table(:student_comments) do
      add :student_id, references(:students, on_delete: :delete_all), null: false
      add :comment, :text
      add :comment_date, :date
      add :done, :boolean, default: false, null: false

      timestamps()
    end

  end
end
