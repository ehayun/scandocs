defmodule Scandoc.Customers.Phone do
  use Ecto.Schema
  import Ecto.Changeset

  schema "phones" do
    field :google_account, :string
    field :google_ref_token, :string
    field :google_token, :string
    field :note, :string
    field :phonenum, :string
    field :provider_token, :string
    field :provider_unique_id, :string
    field :provider_url, :string
    field :sendertype, :string
    field :title, :string
    field :user_id, :string

    timestamps()
  end

  @doc false
  def changeset(phone, attrs) do
    phone
    |> cast(attrs, [
      :phonenum,
      :title,
      :user_id,
      :sendertype,
      :google_account,
      :google_token,
      :google_ref_token,
      :note,
      :provider_url,
      :provider_token,
      :provider_unique_id
    ])
    |> validate_required([
      :phonenum,
      :title,
      :user_id,
      :sendertype,
      :google_account,
      :google_token,
      :google_ref_token,
      :note,
      :provider_url,
      :provider_token,
      :provider_unique_id
    ])
  end
end
