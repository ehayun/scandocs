defmodule Scandoc.Categories.Category do
  use Ecto.Schema
  import Ecto.Changeset

  schema "categories" do
    field :category_name, :string
    field :code, :string

    timestamps()
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:code, :category_name])
    |> validate_required([:code, :category_name])
  end
end
