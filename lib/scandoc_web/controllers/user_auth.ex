defmodule ScandocWeb.UserAuth do
  import Plug.Conn
  import Phoenix.Controller

  import Ecto.Query, warn: false
  alias Scandoc.Repo

  require ScandocWeb.Gettext
  alias ScandocWeb.Gettext

  alias Scandoc.Accounts
  alias ScandocWeb.Router.Helpers, as: Routes

  alias Scandoc.Permissions
  alias Scandoc.Classrooms.Classroom
  alias Scandoc.Students.Student

  # Make the remember me cookie valid for 60 days.
  # If you want bump or reduce this value, also change
  # the token expiry itself in UserToken.
  @max_age 60 * 60 * 24 * 60
  @remember_me_cookie "user_remember_me"
  @remember_me_options [sign: true, max_age: @max_age]

  @doc """
  Logs the user in.

  It renews the session ID and clears the whole session
  to avoid fixation attacks. See the renew_session
  function to customize this behaviour.
  """
  def login_user(conn, user, params \\ %{}) do
    token = Accounts.generate_session_token(user)
    user_return_to = get_session(conn, :user_return_to)

    conn
    |> renew_session()
    |> put_session(:user_token, token)
    |> maybe_write_remember_me_cookie(token, params)
    |> redirect(to: user_return_to || signed_in_path(conn))
  end

  defp maybe_write_remember_me_cookie(conn, token, %{"remember_me" => "true"}) do
    put_resp_cookie(conn, @remember_me_cookie, token, @remember_me_options)
  end

  defp maybe_write_remember_me_cookie(conn, _token, _params) do
    conn
  end

  # This function renews the session ID and erases the whole
  # session to avoid fixation attacks. If there is any data
  # in the session you may want to preserve after login/logout,
  # you must explicitly fetch the session data before clearing
  # and then immediately set it after clearing, for example:
  #
  #     defp renew_session(conn) do
  #       preferred_locale = get_session(conn, :preferred_locale)
  #
  #       conn
  #       |> configure_session(renew: true)
  #       |> clear_session()
  #       |> put_session(:preferred_locale, preferred_locale)
  #     end
  #
  defp renew_session(conn) do
    conn
    |> configure_session(renew: true)
    |> clear_session()
  end

  @doc """
  Logs the user out.

  It clears all session data for safety. See renew_session.
  """
  def logout_user(conn) do
    user_token = get_session(conn, :user_token)
    user_token && Accounts.delete_session_token(user_token)

    conn
    |> renew_session()
    |> delete_resp_cookie(@remember_me_cookie)
    |> redirect(to: "/")
  end

  @doc """
  Authenticates the user by looking into the session
  and remember me token.
  """
  def fetch_current_user(conn, _opts) do
    {user_token, conn} = ensure_user_token(conn)
    user = user_token && Accounts.get_user_by_session_token(user_token)
    assign(conn, :current_user, user)
  end

  defp ensure_user_token(conn) do
    if user_token = get_session(conn, :user_token) do
      {user_token, conn}
    else
      conn = fetch_cookies(conn, signed: [@remember_me_cookie])

      if user_token = conn.cookies[@remember_me_cookie] do
        {user_token, put_session(conn, :user_token, user_token)}
      else
        {nil, conn}
      end
    end
  end

  @doc """
  Used for routes that require the user to not be authenticated.
  """
  def redirect_if_user_is_authenticated(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
      |> redirect(to: signed_in_path(conn))
      |> halt()
    else
      conn
    end
  end

  @doc """
  Used for routes that require the user to be authenticated.

  If you want to enforce the user e-mail is confirmed before
  they use the application at all, here would be a good place.
  """
  def require_authenticated_user(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
    else
      conn
      |> put_flash(:error, Gettext.gettext("You must login to access this page."))
      |> maybe_store_return_to()
      |> redirect(to: Routes.user_session_path(conn, :new))
      |> halt()
    end
  end

  def require_admin_user(conn, _opts) do
    user = conn.assigns[:current_user]

    if user && (user.is_admin || user.role == "000" || isAdmin(user)) do
      conn
    else
      conn
      |> put_flash(:error, Gettext.gettext("You must to be admin to access this page."))
      |> maybe_store_return_to()
      |> redirect(to: Routes.user_session_path(conn, :new))
      |> halt()
    end
  end

  defp maybe_store_return_to(%{method: "GET", request_path: request_path} = conn) do
    put_session(conn, :user_return_to, request_path)
  end

  defp maybe_store_return_to(conn), do: conn

  defp signed_in_path(_conn), do: "/"

  def isAdmin(%Phoenix.LiveView.Socket{} = socket) do
    isAdmin(socket.assigns.current_user)
  end

  def isAdmin(%Plug.Conn{} = conn) do
    isAdmin(conn.assigns.current_user)
  end

  def isAdmin(user), do: Permissions.isAdmin(user)

  defp getScools(user), do: Permissions.getSchools(user.id)
  defp geClassrooms(user), do: Permissions.getClassrooms(user.id)
  defp geStudents(user), do: Permissions.getStudents(user.id)

  def getIds(conn, module) do
    user = conn.assigns.current_user

    IO.inspect(user, label: "getIds #{module}")

    case module do
      :school ->
        getScools(user)

      :classroom ->
        s = getScools(user)
        q = from(c in Classroom, where: c.school_id in ^s)
        c = q |> Repo.all() |> Enum.map(fn u -> u.id end)

        geClassrooms(user) ++ c

      :student ->
        cls = getIds(conn, :classroom)
        q = from(c in Student, where: c.classroom_id in ^cls)
        c = q |> Repo.all() |> Enum.map(fn u -> u.id end)

        geStudents(user) ++ c

      _ ->
        []
    end
  end

  # EOF
end
