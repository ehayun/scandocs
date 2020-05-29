defmodule Scandoc.Repo.Migrations.CreateTansportations do
  use Ecto.Migration

  def change do
    create table(:transportations) do
      add :company_name, :string
      add :company_address, :string
      add :remarks, :text

      timestamps()
    end
  end
end
