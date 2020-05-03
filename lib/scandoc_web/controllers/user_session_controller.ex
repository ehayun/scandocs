defmodule ScandocWeb.UserSessionController do
  use ScandocWeb, :controller

  alias Scandoc.Accounts
  alias ScandocWeb.UserAuth

  def new(conn, _params) do
    render(conn, "new.html", error_message: nil)
  end

  def create(conn, %{"user" => user_params}) do
    %{"zehut" => zehut, "password" => password} = user_params

    if user = Accounts.get_user_by_zehut_and_password(zehut, password) do
      UserAuth.login_user(conn, user, user_params)
    else
      render(conn, "new.html", error_message: "Invalid e-mail or password")
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> UserAuth.logout_user()
  end

  def loginas(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    UserAuth.login_user(conn, user)
  end
end
