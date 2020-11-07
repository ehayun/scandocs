defmodule Scandoc.Repo.Migrations.AddIsLinkToDocgroups do
  use Ecto.Migration

  alias Scandoc.Documents

  def change do
      alter table(:docgroups) do
      add :is_link, :boolean, default: false
    end
  end
end
