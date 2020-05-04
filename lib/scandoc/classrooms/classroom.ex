defmodule Scandoc.Classrooms.Classroom do
  use Ecto.Schema
  import Ecto.Changeset

  schema "classrooms" do
    field :classroom_name, :string
    field :code, :string
    field :school_id, :integer
    field :teacher_id, :integer

    timestamps()
  end

  @doc false
  def changeset(classroom, attrs) do
    classroom
    |> cast(attrs, [:code, :classroom_name, :school_id, :teacher_id])
    |> validate_required([:code, :classroom_name, :school_id, :teacher_id])
  end
end
