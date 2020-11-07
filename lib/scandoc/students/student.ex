defmodule Scandoc.Students.Student do
  use Ecto.Schema
  import Ecto.Changeset
  alias Scandoc.Classrooms.Classroom
  alias Scandoc.Tables.{City, Transportation}
  alias Scandoc.Students.{StudentContact, StudentComment, Stddoc }

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
    field :sending_authority_id, :integer
    field :father_name, :string
    field :mother_name, :string
    field :father_zehut, :string
    field :mother_zehut, :string

    belongs_to :city, City, references: :id
    belongs_to :transportation, Transportation, references: :id

    has_many :comments, StudentComment, references: :id
    has_many :contacts, StudentContact, references: :id
    has_many :documents, Stddoc, references: :id, foreign_key: :ref_id

    timestamps()
  end

  @doc false
  def changeset(student, attrs) do
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
      :transportation_id,
      :sending_authority_id,
      :father_name,
      :mother_name,
      :father_zehut,
      :mother_zehut
    ])
    |> validate_required([:student_zehut, :first_name, :last_name, :classroom_id])
    |> set_full_name()
    |> validate_number(:classroom_id, greater_than: 0)
    |> cast_assoc(:comments)
    |> cast_assoc(:contacts)
    |> cast_assoc(:documents)
  end

  def set_full_name(changeset) do
    first_name = get_field(changeset, :first_name)
    last_name = get_field(changeset, :last_name)
    full_name = "#{last_name} #{first_name}"
    put_change(changeset, :full_name, full_name)
  end
end
