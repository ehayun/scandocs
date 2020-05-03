defmodule ScandocWeb.UserSettingsController do
  use ScandocWeb, :controller

  alias Scandoc.Accounts
  alias ScandocWeb.UserAuth

  plug :assign_zehut_and_password_changesets

  def edit(conn, _params) do
    render(conn, "edit.html")
  end

  def update_zehut(conn, %{"current_password" => password, "user" => user_params}) do
    user = conn.assigns.current_user

    case Accounts.apply_user_zehut(user, password, user_params) do
      {:ok, applied_user} ->
        Accounts.deliver_update_zehut_instructions(
          applied_user,
          user.zehut,
          &Routes.user_settings_url(conn, :confirm_zehut, &1)
        )

        conn
        |> put_flash(
          :info,
          "A link to confirm your e-mail change has been sent to the new address."
        )
        |> redirect(to: Routes.user_settings_path(conn, :edit))

      {:error, changeset} ->
        render(conn, "edit.html", zehut_changeset: changeset)
    end
  end

  def confirm_zehut(conn, %{"token" => token}) do
    case Accounts.update_user_zehut(conn.assigns.current_user, token) do
      :ok ->
        conn
        |> put_flash(:info, "E-mail changed successfully.")
        |> redirect(to: Routes.user_settings_path(conn, :edit))

      :error ->
        conn
        |> put_flash(:error, "Zehut change link is invalid or it has expired.")
        |> redirect(to: Routes.user_settings_path(conn, :edit))
    end
  end

  def update_password(conn, %{"current_password" => password, "user" => user_params}) do
    user = conn.assigns.current_user

    case Accounts.update_user_password(user, password, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Password updated successfully.")
        |> put_session(:user_return_to, Routes.user_settings_path(conn, :edit))
        |> UserAuth.login_user(user)

      {:error, changeset} ->
        render(conn, "edit.html", password_changeset: changeset)
    end
  end

  defp assign_zehut_and_password_changesets(conn, _opts) do
    user = conn.assigns.current_user

    conn
    |> assign(:zehut_changeset, Accounts.change_user_zehut(user))
    |> assign(:password_changeset, Accounts.change_user_password(user))
  end
end
