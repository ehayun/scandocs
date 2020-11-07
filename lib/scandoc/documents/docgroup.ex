defmodule Scandoc.Documents.Docgroup do
  use Ecto.Schema
  import Ecto.Changeset

  schema "docgroups" do
    field :grp_name, :string
    field :is_link, :boolean, default: false
    timestamps()
  end

  @doc false
  def changeset(docgroup, attrs) do
    docgroup
    |> cast(attrs, [:id, :grp_name, :is_link])
    |> validate_required([:grp_name])
  end
end
