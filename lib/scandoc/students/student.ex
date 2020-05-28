defmodule Scandoc.Students.Student do
  use Ecto.Schema
  import Ecto.Changeset
  alias Scandoc.Classrooms.Classroom
  alias Scandoc.Tables.City
  alias Scandoc.Students.{StudentContact, StudentComment}

  schema "students" do
    belongs_to :classroom, Classroom, references: :id
    field :school_id, :integer, virtual: true
    field :full_name, :string
    field :has_picture, :boolean, default: false
    field :student_zehut, :string, unique: true

    field :last_name, :string
    field :first_name, :string
    field :birthdate, :date
    field :age, :float, virtual: true
    field :hebrew_birthdate, :string
    field :gender, :string
    field :address, :string
    field :healthcare, :string
    belongs_to :city, City, references: :id
    field :sending_authority_id, :integer
    field :father_name, :string
    field :mother_name, :string
    field :father_zehut, :string
    field :mother_zehut, :string
    has_many :comments, StudentComment, references: :id
    has_many :contacts, StudentContact, references: :id

    timestamps()
  end

  @doc false
  def changeset(student, attrs) do
    attrs = Map.merge(attrs, fullname(attrs))

    student
    |> cast(attrs, [
      :student_zehut,
      :full_name,
      :has_picture,
      :classroom_id,
      :school_id,
      :last_name,
      :first_name,
      :birthdate,
      :age,
      :hebrew_birthdate,
      :gender,
      :address,
      :healthcare,
      :city_id,
      :sending_authority_id,
      :father_name,
      :mother_name,
      :father_zehut,
      :mother_zehut
    ])
    |> validate_required([:student_zehut, :first_name, :last_name, :classroom_id])
    |> unique_constraint(:student_zehut)
    |> cast_assoc(:comments)
    |> cast_assoc(:contacts)
  end

  defp fullname(%{"last_name" => last_name, "first_name" => first_name}) do
    %{"full_name" => "#{last_name} #{first_name}"}
  end

  defp fullname(%{last_name: last_name, first_name: first_name}) do
    %{full_name: "#{last_name} #{first_name}"}
  end

  defp fullname(_params) do
    %{}
  end
end
