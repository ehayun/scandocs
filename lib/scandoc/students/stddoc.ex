defmodule Scandoc.Students.Stddoc do
  use Ecto.Schema
  import Ecto.Changeset
  alias Scandoc.Documents.{Doctype, DocComments}

  schema "documents" do
    field :doc_name, :string
    field :doc_name_len, :integer
    field :doc_path, :string
    belongs_to :doctype, Doctype, references: :id
    field :has_picture, :boolean, default: false
    field :line_code, :string
    field :ref_id, :integer
    field :ref_date, :date
    field :ref_month, :string
    field :ref_year, :string
    field :remarks, :string
    field :done, :boolean, default: false

    has_many :comments, DocComments, references: :doc_name, foreign_key: :doc_name

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
      :ref_date,
      :doctype_id,
      :remarks,
      :done,
      :has_picture
    ])
    |> validate_required([
      :line_code,
      :doc_name,
      :doc_name_len,
      :doc_path,
      :ref_id,
      :ref_year,
      :ref_month,
      :doctype_id,
      :has_picture
    ])
    |> cast_assoc(:comments)
  end
end
