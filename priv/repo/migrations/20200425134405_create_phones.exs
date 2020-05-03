defmodule Scandoc.Repo.Migrations.CreatePhones do
  use Ecto.Migration

  def change do
    create table(:phones) do
      add :phonenum, :string
      add :title, :text
      add :user_id, references(:users, on_delete: :delete_all)

      add :sendertype, :string
      add :google_account, :string
      add :google_token, :string
      add :google_ref_token, :string
      add :note, :text
      add :provider_url, :string
      add :provider_token, :string
      add :provider_unique_id, :string

      timestamps()
    end
  end
end
