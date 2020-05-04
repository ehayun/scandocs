defmodule Scandoc.Students.Student do
  use Ecto.Schema
  import Ecto.Changeset

  schema "students" do
    field :classroom_id, :integer
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
