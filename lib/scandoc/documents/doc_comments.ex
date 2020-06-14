defmodule Scandoc.Documents.DocComments do
  use Ecto.Schema
  import Ecto.Changeset

  alias Scandoc.Documents.Document

  schema "document_comments" do
    field :doc_note, :string
    field :done, :boolean, default: false
    field :document_doc_name, :string

    field :temp_id, :string, virtual: true
    field :delete, :boolean, virtual: true, default: false

    timestamps()
  end

  @doc false
  def changeset(doc_comments, attrs) do
    doc_comments
    |> cast(attrs, [:done, :doc_note, :document_doc_name, :delete])
    |> validate_required([:document_doc_name])
  end
end
