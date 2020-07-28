defmodule Scandoc.Repo.Migrations.AddRemarkToDocument do
  use Ecto.Migration

  def change do
    alter table(:documents) do
      add :remarks, :text
      add :done, :boolean
    end
  end
end
