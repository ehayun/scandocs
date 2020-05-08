defmodule Scandoc.Repo.Migrations.CreateDocuments do
  use Ecto.Migration

  def change do
    create table(:documents) do
      add :line_code, :string
      add :doc_name, :string
      add :doc_name_len, :integer
      add :doc_path, :string
      add :ref_id, :integer
      add :ref_year, :string
      add :ref_month, :string
      add :ref_date, :date
      add :doctype_id, references(:doctypes, on_delete: :nothing), null: false
      add :has_picture, :boolean, default: false, null: false

      timestamps()
    end
  end
end
