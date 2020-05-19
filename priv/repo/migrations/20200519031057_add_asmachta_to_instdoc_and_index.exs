defmodule Scandoc.Repo.Migrations.AddAsmachtaToInstdocAndIndex do
  use Ecto.Migration

  def change do
    alter table(:inst_docs) do
      add :asmachta, :string
    end

    create index(:inst_docs, [:asmachta])
    create index(:inst_docs, [:vendor_name])
    create index(:inst_docs, [:payment_code])
  end
end
