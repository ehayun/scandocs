defmodule Scandoc.Repo.Migrations.CreateDistricts do
  use Ecto.Migration

  def change do
    create table(:districts) do
      add :district_name, :string

      timestamps()
    end
  end
end
