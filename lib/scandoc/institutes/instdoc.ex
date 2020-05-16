defmodule Scandoc.Institutes.Instdoc do
  use Ecto.Schema
  import Ecto.Changeset

  schema "inst_docs" do
    field :amount, :decimal
    field :category_id, :integer
    field :institute_id, :string
    field :doc_date, :date
    field :doc_name, :string
    field :doc_path, :string
    field :line_code, :string
    field :outcome_category_id, :integer
    field :payment_code, :string
    field :vendor_id, :integer

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
      :vendor_id,
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
      :vendor_id,
      :outcome_category_id,
      :doc_date,
      :amount,
      :doc_name,
      :doc_path
    ])
  end
end
