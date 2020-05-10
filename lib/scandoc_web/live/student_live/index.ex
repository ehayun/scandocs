defmodule ScandocWeb.StudentLive.Index do
  use ScandocWeb, :live_view

  import Ecto.Query
  alias Scandoc.Repo

  alias Scandoc.Accounts.UserToken

  alias Scandoc.Students
  alias Scandoc.Students.Student

  alias Scandoc.Accounts.User

  alias ScandocWeb.UserAuth

  @impl true
  def mount(_params, session, socket) do
    %{"user_token" => user_token} = session
    u = UserToken |> where(token: ^user_token) |> Repo.one()

    user =
      if u do
        User |> where(id: ^u.user_id) |> Repo.one()
      end

    socket =
      socket
      |> assign(current_user: user)

    {:ok, assign(socket, :students, fetch_students(socket))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Student")
    |> assign(:student, Students.get_student!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Student")
    |> assign(:student, %Student{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Students")
    |> assign(:student, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    student = Students.get_student!(id)
    {:ok, _} = Students.delete_student(student)

    {:noreply, assign(socket, :students, fetch_students(socket))}
  end

  defp fetch_students(socket) do
    stdList = UserAuth.getIds(socket, :student)

    query = ""
    current_page = 1
    q = Student

    q =
      if query == "" do
        q
      else
        from(s in q,
          where: ilike(s.full_name, ^"%#{query}%"),
          or_where: like(s.student_zehut, ^"%#{query}%")
        )
      end

    q =
      if UserAuth.isAdmin(socket) do
        q
      else
        from(c in q, where: c.id in ^stdList)
      end

    students =
      q
      |> order_by(:full_name)
      |> preload(:classroom)
      |> Repo.paginate(page: current_page, page_size: 14)

    students
  end
end
