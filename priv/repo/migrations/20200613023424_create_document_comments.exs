defmodule Scandoc.Repo.Migrations.CreateDocumentComments do
  use Ecto.Migration

  def change do
    create table(:document_comments) do
      add :done, :boolean, default: false, null: false
      add :doc_note, :text
      add :doc_name, references(:documents, column: :doc_name, type: :string, on_delete: :nothing)

      timestamps()
    end

    create index(:document_comments, [:doc_name])
  end
end
