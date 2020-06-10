defmodule Scandoc.Repo.Migrations.CreateUsersAuthTables do
  use Ecto.Migration

  def change do
    # execute "CREATE EXTENSION IF NOT EXISTS citext", ""

    create table(:users) do
      add :zehut, :string, null: false
      add :hashed_password, :string, null: false
      add :confirmed_at, :naive_datetime
      add :full_name, :string, null: false
      add :role, :string, default: "020"
      add :date_of_birth, :date
      add :is_freezed, :boolean, default: false
      add :is_admin, :boolean, default: false
      timestamps()
    end

    create unique_index(:users, [:zehut])

    create table(:users_tokens) do
      add :user_id, references(:users, on_delete: :delete_all, on_update: :update_all), null: false
      add :token, :binary, null: false
      add :context, :string, null: false
      add :sent_to, :string
      timestamps(updated_at: false)
    end

    create unique_index(:users_tokens, [:context, :token])
  end
end
