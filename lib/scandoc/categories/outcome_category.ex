defmodule Scandoc.Categories.OutcomeCategory do
  use Ecto.Schema
  import Ecto.Changeset

  schema "outcome_categoryes" do
    field :category_id, :integer
    field :outcome_card, :string
    field :outcome_description, :string

    timestamps()
  end

  @doc false
  def changeset(outcome_category, attrs) do
    outcome_category
    |> cast(attrs, [:outcome_card, :category_id, :outcome_description])
    |> validate_required([:outcome_card, :category_id, :outcome_description])
  end
end
