defmodule Scandoc.Repo.Migrations.CreateDoctypes do
  use Ecto.Migration

  def change do
    create table(:doctypes) do
      add :code, :string
      add :doc_group, :integer, default: 1
      add :doc_name, :string
      add :doc_notes, :text

      timestamps()
    end
  end
end
