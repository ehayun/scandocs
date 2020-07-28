defmodule Scandoc.Documents.Document do
  use Ecto.Schema
  import Ecto.Changeset

  alias Scandoc.Documents.{Doctype}

  schema "documents" do
    field :doc_name, :string
    field :doc_name_len, :integer
    field :doc_path, :string
    belongs_to :doctype, Doctype, references: :id
    field :has_picture, :boolean, default: false
    field :line_code, :string
    field :ref_id, :integer
    field :ref_month, :string
    field :ref_year, :string
    field :remarks, :string
    field :done, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(document, attrs) do
    document
    |> cast(attrs, [
      :line_code,
      :doc_name,
      :doc_name_len,
      :doc_path,
      :ref_id,
      :ref_year,
      :ref_month,
      :doctype_id,
      :remarks,
      :done,
      :has_picture
    ])
    |> validate_required([
      :line_code,
      :doc_name,
      :doc_path,
      :ref_id,
      :doctype_id
    ])
    |> unique_constraint(:doc_name)
  end
end
