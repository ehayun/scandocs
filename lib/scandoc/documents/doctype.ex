defmodule Scandoc.Documents.Doctype do
  use Ecto.Schema
  import Ecto.Changeset

  alias Scandoc.Documents.Docgroup

  schema "doctypes" do
    field :code, :string
    belongs_to :doc_group, Docgroup, references: :id
    field :doc_name, :string
    field :doc_notes, :string

    timestamps()
  end

  @doc false
  def changeset(doctype, attrs) do
    doctype
    |> cast(attrs, [:code, :doc_group_id, :doc_name, :doc_notes])
    |> validate_required([:code, :doc_name])
  end
end
