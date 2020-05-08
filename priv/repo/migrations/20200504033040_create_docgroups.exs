defmodule Scandoc.Repo.Migrations.CreateDocgroups do
  use Ecto.Migration

  def change do
    create table(:docgroups) do
      add :grp_name, :string

      timestamps()
    end

  end
end
