defmodule Scandoc.Customers.Customer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :zehut, :string
    field :password, :string, virtual: true
    field :hashed_password, :string
    field :confirmed_at, :naive_datetime
    field :first_name, :string
    field :last_name, :string
    field :role, :string, default: "customer"
    field :is_freezed, :boolean, default: false

    timestamps()
  end

  def changeset(user, attrs) do
    {password, hashed_password} =
      case user do
        %{"password" => password, "hashed_password" => hashed_password} ->
          {password, hashed_password}

        %{password: password, hashed_password: hashed_password} ->
          {password, hashed_password}

        _ ->
          {nil, nil}
      end

    IO.inspect(user, label: "[#{password}] [#{hashed_password}]")

    cs =
      user
      |> cast(attrs, [
        :zehut,
        :hashed_password,
        :password,
        :first_name,
        :last_name,
        :role,
        :is_freezed
      ])
      |> validate_required([:zehut, :first_name, :last_name, :role])

    cs =
      if user.id != nil do
        cs
        |> validate_zehut()
      else
        cs
        |> validate_zehut()
      end

    cs =
      if password > "" do
        cs
        |> validate_password()
      else
        if hashed_password == nil do
          cs
          |> validate_password()
        else
          cs
        end
      end

    cs
  end

  defp validate_zehut(changeset) do
    changeset
    |> validate_required([:zehut])
    |> validate_length(:zehut, max: 15)
    |> unsafe_validate_unique(:zehut, Scandoc.Repo)
    |> unique_constraint(:zehut)
  end

  defp validate_password(changeset) do
    changeset
    |> validate_required([:password])
    |> validate_length(:password, min: 5, max: 80)
    # |> validate_format(:password, ~r/[a-z]/, message: "at least one lower case character")
    # |> validate_format(:password, ~r/[A-Z]/, message: "at least one upper case character")
    # |> validate_format(:password, ~r/[!?@#$%^&*_0-9]/, message: "at least one digit or punctuation character")
    |> maybe_hash_password()
  end

  defp maybe_hash_password(changeset) do
    password = get_change(changeset, :password)

    if password && changeset.valid? do
      changeset
      |> put_change(:hashed_password, Bcrypt.hash_pwd_salt(password))
      |> delete_change(:password)
    else
      changeset
    end
  end
end
