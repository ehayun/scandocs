defmodule Scandoc.Documents.DocComments do
  use Ecto.Schema
  import Ecto.Changeset

  alias Scandoc.Documents.Document
  alias Scandoc.Students.Stddoc

  schema "document_comments" do
    field :doc_note, :string
    field :done, :boolean, default: false

    belongs_to :stddoc, Stddoc, references: :doc_name, foreign_key: :doc_name, type: :string

    field :temp_id, :string, virtual: true
    field :delete, :boolean, virtual: true, default: false

    timestamps()
  end

  @doc false
  def changeset(doc_comments, attrs) do
    doc_comments
    |> cast(attrs, [:done, :doc_note, :doc_name, :delete])
    |> validate_required([:doc_name])
    |> maybe_mark_for_deletion()
  end

  defp maybe_mark_for_deletion(
         %{
           data: %{
             id: nil
           }
         } = changeset
       ),
       do: changeset

  defp maybe_mark_for_deletion(changeset) do
    if get_change(changeset, :delete) do
      %{changeset | action: :delete}
    else
      changeset
    end
  end
end
