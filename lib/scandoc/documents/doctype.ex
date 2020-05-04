defmodule Scandoc.Documents.Doctype do
  use Ecto.Schema
  import Ecto.Changeset

  schema "doctypes" do
    field :code, :string
    field :doc_group, :integer, default: 1
    field :doc_name, :string
    field :doc_notes, :string

    timestamps()
  end

  @doc false
  def changeset(doctype, attrs) do
    doctype
    |> cast(attrs, [:code, :doc_group, :doc_name, :doc_notes])
    |> validate_required([:code, :doc_name])
  end
end
