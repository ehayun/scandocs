defmodule Scandoc.Permissions.Permission do
  use Ecto.Schema
  import Ecto.Changeset
  alias Scandoc.Accounts.User

  schema "permissions" do
    field :permission_type, :integer
    field :ref_id, :integer
    belongs_to :user, User, references: :id

    timestamps()
  end

  @doc false
  def changeset(permission, attrs) do
    permission
    |> cast(attrs, [:user_id, :permission_type, :ref_id])
    |> validate_required([:user_id, :permission_type, :ref_id])
  end
end
