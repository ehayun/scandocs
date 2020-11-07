defmodule Scandoc.Students.Stddoc do
  use Ecto.Schema
  import Ecto.Changeset
  alias Scandoc.Documents.{Doctype, DocComments}

  schema "documents" do
    field :doc_name, :string
    field :doc_name_len, :integer, default: 99
    field :doc_path, :string
    belongs_to :doctype, Doctype, references: :id
    field :has_picture, :boolean, default: false
    field :line_code, :string, default: "99999"
    field :ref_id, :integer
    field :ref_date, :date
    field :ref_month, :string, default: "00"
    field :ref_year, :string, default: "00"
    field :remarks, :string
    field :done, :boolean, default: false

    field :temp_id, :string, virtual: true
    field :delete, :boolean, virtual: true, default: false


    has_many :comments, DocComments, references: :doc_name, foreign_key: :doc_name

    timestamps()
  end

  @doc false
  def changeset(document, attrs) do
    document
    |> cast(
         attrs,
         [
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
         ]
       )
    |> validate_required(
         [
           :line_code,
           :doc_name,
           :doc_name_len,
           :doc_path,
           :ref_id,
           :doctype_id,
           :has_picture
         ]
       )
    |> unique_constraint(:doc_name)
    |> cast_assoc(:comments)
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
