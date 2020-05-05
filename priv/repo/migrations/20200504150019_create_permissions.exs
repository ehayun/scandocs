defmodule Scandoc.Repo.Migrations.CreatePermissions do
  use Ecto.Migration

  def change do
    create table(:permissions) do
      add :user_id, :integer
      add :permission_type, :integer
      add :ref_id, :integer

      timestamps()
    end

  end
end
