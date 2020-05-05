defmodule Scandoc.Schools.Teacher do
  use Ecto.Schema
  import Ecto.Changeset
  alias Scandoc.Classrooms.Classroom

  schema "users" do
    field :date_of_birth, :date
    field :full_name, :string
    field :hashed_password, :string
    field :role, :string, default: "030"
    field :zehut, :string
    has_many :classroom, Classroom, references: :id

    timestamps()
  end

  @doc false
  def changeset(teacher, attrs) do
    teacher
    |> cast(attrs, [:zehut, :full_name, :role, :date_of_birth, :hashed_password])
    |> validate_required([:zehut, :full_name, :role, :date_of_birth, :hashed_password])
  end
end
