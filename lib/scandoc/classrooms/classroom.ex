defmodule Scandoc.Classrooms.Classroom do
  use Ecto.Schema
  import Ecto.Changeset
  alias Scandoc.Schools.School
  alias Scandoc.Schools.Teacher

  schema "classrooms" do
    field :classroom_name, :string
    field :code, :string
    belongs_to :teacher, Teacher, references: :id
    belongs_to :school, School, references: :id

    timestamps()
  end

  @doc false
  def changeset(classroom, attrs) do
    classroom
    |> cast(attrs, [:code, :classroom_name, :school_id, :teacher_id])
    |> validate_required([:code, :classroom_name, :school_id, :teacher_id])
  end
end
