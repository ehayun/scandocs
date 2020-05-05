defmodule Scandoc.Permissions.Permission do
  use Ecto.Schema
  import Ecto.Changeset

  schema "permissions" do
    field :permission_type, :integer
    field :ref_id, :integer
    field :user_id, :integer

    timestamps()
  end

  @doc false
  def changeset(permission, attrs) do
    permission
    |> cast(attrs, [:user_id, :permission_type, :ref_id])
    |> validate_required([:user_id, :permission_type, :ref_id])
  end
end
