defmodule Scandoc.Repo.Migrations.CreateCities do
  use Ecto.Migration

  def change do
    create table(:cities) do
      add :code, :string
      add :title, :string

      timestamps()
    end
  end
end
