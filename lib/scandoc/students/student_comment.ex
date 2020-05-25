defmodule Scandoc.Students.StudentComment do
  use Ecto.Schema
  import Ecto.Changeset

  alias Scandoc.Students.Student

  schema "student_comments" do
    field :comment, :string
    field :comment_date, :date, default: Calendar.Date.today_utc()
    field :done, :boolean, default: false
    belongs_to :student, Student, references: :id
    field :temp_id, :string, virtual: true
    field :delete, :boolean, virtual: true, default: false

    timestamps()
  end

  @doc false
  def changeset(student_comment, attrs) do
    student_comment
    |> cast(attrs, [:student_id, :comment, :comment_date, :done, :delete])
    |> validate_required([:student_id, :comment_date, :done, :comment])
    |> maybe_mark_for_deletion()
  end

  defp maybe_mark_for_deletion(%{data: %{id: nil}} = changeset), do: changeset

  defp maybe_mark_for_deletion(changeset) do
    if get_change(changeset, :delete) do
      %{changeset | action: :delete}
    else
      changeset
    end
  end
end
