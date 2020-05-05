defmodule Scandoc.Students.Student do
  use Ecto.Schema
  import Ecto.Changeset
  alias Scandoc.Classrooms.Classroom

  schema "students" do
    belongs_to :classroom, Classroom, references: :id
    field :full_name, :string
    field :has_picture, :boolean, default: false
    field :student_zehut, :string

    timestamps()
  end

  @doc false
  def changeset(student, attrs) do
    student
    |> cast(attrs, [:student_zehut, :full_name, :has_picture, :classroom_id])
    |> validate_required([:student_zehut, :full_name, :has_picture, :classroom_id])
  end
end
