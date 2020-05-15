defmodule Scandoc.Repo.Migrations.CreateInstDocs do
  use Ecto.Migration

  def change do
    create table(:inst_docs) do
      add :institute_id, references(:institutes, on_delete: :nothing), null: false
      add :category_id, references(:categories, on_delete: :nothing), null: false

      add :payment_code, :string, null: false
      add :line_code, :string, null: false

      add :vendor_id, references(:vendors, on_delete: :nothing), null: false

      add :outcome_category_id, references(:outcome_categoryes, on_delete: :nothing), null: false

      add :doc_date, :date
      add :amount, :decimal, default: 0.0
      add :doc_name, :string, null: false
      add :doc_path, :string, null: false

      timestamps()
    end
  end
end
