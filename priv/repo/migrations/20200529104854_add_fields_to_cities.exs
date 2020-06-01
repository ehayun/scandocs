defmodule Scandoc.Repo.Migrations.AddFieldsToCities do
  use Ecto.Migration
  alias Scandoc.Tables

  def change do
    alter table(:cities) do
      add :district_id, references(:districts, on_delete: :nothing)
    end
  end
end
