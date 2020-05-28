defmodule Scandoc.Repo.Migrations.CreateStudentContacts do
  use Ecto.Migration

  def change do
    create table(:student_contacts) do
      add :student_id, references(:students, on_delete: :delete_all), null: false
      add :contact_name, :string
      add :contact_type, :string
      add :contact_value, :string
      add :remark, :string

      timestamps()
    end
  end
end
