defmodule Scandoc.Repo.Migrations.AddFieldsToCities do
  use Ecto.Migration
  alias Scandoc.Tables

  def change do
    Tables.create_district(%{district_name: "לא מוגדר"})

    alter table(:cities) do
      add :district, references(:districts, on_delete: :nothing), null: false, default: 1
    end
  end
end
