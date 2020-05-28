defmodule Scandoc.Students.StudentContact do
  use Ecto.Schema
  import Ecto.Changeset

  alias Scandoc.Students.Student

  schema "student_contacts" do
    field :contact_name, :string
    field :contact_type, :string, default: "mobile"
    field :contact_value, :string
    field :remark, :string
    belongs_to :student, Student, references: :id
    field :temp_id, :string, virtual: true
    field :delete, :boolean, virtual: true, default: false

    timestamps()
  end

  @doc false
  def changeset(student_contact, attrs) do
    student_contact
    |> cast(attrs, [:student_id, :contact_name, :contact_type, :contact_value, :remark, :delete])
    |> validate_required([:student_id, :contact_name, :contact_type, :contact_value])
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
