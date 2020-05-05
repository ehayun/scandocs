defmodule ScandocWeb.TeacherController do
  use ScandocWeb, :controller

  alias Scandoc.Schools
  alias Scandoc.Schools.Teacher
  import Ecto.Query

  alias Scandoc.Repo

  def index(conn, %{"page" => current_page}) do
    teachers =
      Teacher
      |> where(role: "030")
      |> order_by(:full_name)
      |> Repo.paginate(page: current_page, page_size: 15)

    conn
    |> assign(:teachers, teachers)
    |> render("index.html")
  end

  def index(conn, _params), do: index(conn, %{"page" => "1"})

  def new(conn, _params) do
    changeset = Schools.change_teacher(%Teacher{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"teacher" => teacher_params}) do
    case Schools.create_teacher(teacher_params) do
      {:ok, teacher} ->
        conn
        |> put_flash(:info, "Teacher created successfully.")
        |> redirect(to: Routes.teacher_path(conn, :show, teacher))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    teacher = Schools.get_teacher!(id)
    render(conn, "show.html", teacher: teacher)
  end

  def edit(conn, %{"id" => id}) do
    teacher = Schools.get_teacher!(id)
    changeset = Schools.change_teacher(teacher)
    render(conn, "edit.html", teacher: teacher, changeset: changeset)
  end

  def update(conn, %{"id" => id, "teacher" => teacher_params}) do
    teacher = Schools.get_teacher!(id)

    case Schools.update_teacher(teacher, teacher_params) do
      {:ok, teacher} ->
        conn
        |> put_flash(:info, "Teacher updated successfully.")
        |> redirect(to: Routes.teacher_path(conn, :show, teacher))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", teacher: teacher, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    teacher = Schools.get_teacher!(id)
    {:ok, _teacher} = Schools.delete_teacher(teacher)

    conn
    |> put_flash(:info, "Teacher deleted successfully.")
    |> redirect(to: Routes.teacher_path(conn, :index))
  end
end
