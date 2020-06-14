defmodule Scandoc.Institutes.Instdoc do
  use Ecto.Schema
  import Ecto.Changeset

  alias Scandoc.Institutes.Institute
  alias Scandoc.Categories.Category
  alias Scandoc.Categories.OutcomeCategory
  alias Scandoc.Documents.DocComments

  schema "inst_docs" do
    field :amount, :decimal
    belongs_to :category, Category, references: :id
    belongs_to :institute, Institute, references: :id
    belongs_to :outcome_category, OutcomeCategory, references: :id

    field :doc_date, :date
    field :doc_name, :string
    field :doc_path, :string
    field :line_code, :string
    field :asmachta, :string
    field :payment_code, :string
    field :vendor_name, :string

    has_many :comments, DocComments, references: :doc_name


    timestamps()
  end

  @doc false
  def changeset(instdoc, attrs) do
    instdoc
    |> cast(attrs, [
      :institute_id,
      :category_id,
      :payment_code,
      :line_code,
      :asmachta,
      :vendor_name,
      :outcome_category_id,
      :doc_date,
      :amount,
      :doc_name,
      :doc_path
    ])
    |> validate_required([
      :institute_id,
      :category_id,
      :payment_code,
      :line_code,
      :vendor_name,
      :outcome_category_id,
      :doc_date,
      :amount,
      :doc_name,
      :doc_path
    ])
  end
end
