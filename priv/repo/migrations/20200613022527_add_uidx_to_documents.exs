defmodule Scandoc.Repo.Migrations.AddUidxToDocuments do
  use Ecto.Migration

  def change do
    create unique_index(:documents, [:doc_name])
  end
end
