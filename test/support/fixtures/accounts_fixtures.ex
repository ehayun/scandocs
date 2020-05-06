defmodule Scandoc.AccountsFixtures do
  def unique_user_zehut, do: "user#{System.unique_integer()}@example.com"
  def valid_user_password, do: "hello world!"

  def valid_firstname, do: "first_#{System.unique_integer()}"
  def valid_lastname, do: "last_#{System.unique_integer()}"

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        zehut: unique_user_zehut(),
        password: valid_user_password(),
        first_name: valid_firstname(),
        last_name: valid_lastname()
      })
      |> Scandoc.Accounts.register_user()

    user
  end

  def extract_user_token(fun) do
    {:ok, captured} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token, _] = String.split(captured.body, "[TOKEN]")
    token
  end
end
