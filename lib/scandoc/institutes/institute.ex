defmodule Scandoc.Institutes.Institute do
  use Ecto.Schema
  import Ecto.Changeset

  schema "institutes" do
    field :code, :string
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(institute, attrs) do
    institute
    |> cast(attrs, [:code, :title])
    |> validate_required([:code, :title])
  end
end
