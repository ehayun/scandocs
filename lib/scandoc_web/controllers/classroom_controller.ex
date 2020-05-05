defmodule ScandocWeb.ClassroomController do
  use ScandocWeb, :controller

  import Ecto.Query
  alias Scandoc.Repo

  alias Scandoc.Classrooms
  alias Scandoc.Classrooms.Classroom

  def index(conn, %{"page" => current_page}) do
    # classrooms = Classrooms.list_classrooms()
    # render(conn, "index.html", classrooms: classrooms)

    classrooms =
      Classroom
      |> order_by(:school_id)
      |> preload(:school)
      |> preload(:teacher)
      |> Repo.paginate(page: current_page, page_size: 17)

    conn
    |> assign(:classrooms, classrooms)
    |> render("index.html")
  end

  def index(conn, _params), do: index(conn, %{"page" => "1"})

  def new(conn, _params) do
    changeset = Classrooms.change_classroom(%Classroom{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"classroom" => classroom_params}) do
    case Classrooms.create_classroom(classroom_params) do
      {:ok, classroom} ->
        conn
        |> put_flash(:info, "Classroom created successfully.")
        |> redirect(to: Routes.classroom_path(conn, :show, classroom))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    classroom = Classrooms.get_classroom!(id)
    render(conn, "show.html", classroom: classroom)
  end

  def edit(conn, %{"id" => id}) do
    classroom = Classrooms.get_classroom!(id)
    changeset = Classrooms.change_classroom(classroom)
    render(conn, "edit.html", classroom: classroom, changeset: changeset)
  end

  def update(conn, %{"id" => id, "classroom" => classroom_params}) do
    classroom = Classrooms.get_classroom!(id)

    case Classrooms.update_classroom(classroom, classroom_params) do
      {:ok, classroom} ->
        conn
        |> put_flash(:info, "Classroom updated successfully.")
        |> redirect(to: Routes.classroom_path(conn, :show, classroom))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", classroom: classroom, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    classroom = Classrooms.get_classroom!(id)
    {:ok, _classroom} = Classrooms.delete_classroom(classroom)

    conn
    |> put_flash(:info, "Classroom deleted successfully.")
    |> redirect(to: Routes.classroom_path(conn, :index))
  end
end
