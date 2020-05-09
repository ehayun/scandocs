defmodule Scandoc.Documents.Docgroup do
  use Ecto.Schema
  import Ecto.Changeset

  schema "docgroups" do
    field :grp_name, :string

    timestamps()
  end

  @doc false
  def changeset(docgroup, attrs) do
    docgroup
    |> cast(attrs, [:id, :grp_name])
    |> validate_required([:grp_name])
  end
end
