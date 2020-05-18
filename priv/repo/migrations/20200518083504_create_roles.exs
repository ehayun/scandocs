defmodule Scandoc.Repo.Migrations.CreateRoles do
  use Ecto.Migration

  def change do
    create table(:roles) do
      add :code, :string
      add :title, :string

      timestamps()
    end

  end
end
