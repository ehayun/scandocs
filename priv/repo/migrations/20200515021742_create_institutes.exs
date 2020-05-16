defmodule Scandoc.Repo.Migrations.CreateInstitutes do
  use Ecto.Migration

  def change do
    create table(:institutes) do
      add :code, :string
      add :title, :string

      timestamps()
    end
  end
end
