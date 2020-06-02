defmodule Scandoc.Tables.City do
  use Ecto.Schema
  import Ecto.Changeset

  alias Scandoc.Tables.District
  alias Scandoc.City.{CityAddress, CityContact}

  schema "cities" do
    field :code, :string
    field :title, :string

    belongs_to :district, District, references: :id

    has_many :contacts, CityContact, references: :id
    has_many :addresses, CityAddress, references: :id

    timestamps()
  end

  @doc false
  def changeset(city, attrs) do
    city
    |> cast(attrs, [:code, :title, :district_id])
    |> validate_required([:code, :title, :district_id])
    |> cast_assoc(:contacts)
    |> cast_assoc(:addresses)
  end
end
