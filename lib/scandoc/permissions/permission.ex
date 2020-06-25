defmodule Scandoc.Permissions.Permission do
  use Ecto.Schema
  import Ecto.Changeset
  alias Scandoc.Accounts.User

  schema "permissions" do
    field :permission_type, :integer
    field :ref_id, :integer, default: 0

    field :school_id, :integer, virtual: true
    field :classroom_id, :integer, virtual: true
    field :student_id, :integer, virtual: true
    field :vendor_name, :integer, virtual: true
    field :institute_id, :integer, virtual: true

    belongs_to :user, User, references: :id

    field :temp_id, :string, virtual: true
    field :delete, :boolean, virtual: true, default: false

    timestamps()
  end

  @doc false
  def changeset(permission, attrs) do
    permission
    |> cast(attrs, [:user_id, :permission_type, :ref_id, :delete])
    |> validate_required([:user_id, :permission_type, :ref_id])
  end
end
