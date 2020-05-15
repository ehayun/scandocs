defmodule Scandoc.Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :code, :string
      add :category_name, :string

      timestamps()
    end

  end
end
