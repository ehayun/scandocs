defmodule Scandoc.Repo.Migrations.CreateOutcomeCategoryes do
  use Ecto.Migration

  def change do
    create table(:outcome_categoryes) do
      add :outcome_card, :string
      add :category_id, references(:categories, on_delete: :nothing), null: false

      add :outcome_description, :string

      timestamps()
    end
  end
end
