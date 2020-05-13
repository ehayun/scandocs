defmodule ScandocWeb.ClassroomController do
  use ScandocWeb, :controller

  import Ecto.Query
  alias Scandoc.Repo

  alias Scandoc.Classrooms
  alias Scandoc.Students
  alias Scandoc.Classrooms.Classroom

  alias ScandocWeb.UserAuth

  def index(conn, %{"page" => current_page, "school" => schoolId}) do
    # classrooms = Classrooms.list_classrooms()
    # render(conn, "index.html", classrooms: classrooms)
    classList = UserAuth.getIds(conn, :classroom)
    schoolId = String.to_integer(schoolId)

    q = Classroom

    q =
      if UserAuth.isAdmin(conn) do
        q
      else
        from(c in q, where: c.id in ^classList)
      end

    q =
      if schoolId > 0 do
        from(c in q, where: c.school_id == ^schoolId)
      else
        q
      end

    classrooms =
      q
      |> order_by(:school_id)
      |> preload(:school)
      |> preload(:teacher)
      |> Repo.paginate(page: current_page, page_size: 17)

    conn
    |> assign(:classrooms, classrooms)
    |> render("index.html")
  end

  def index(conn, params) do
    schoolId =
      case params do
        %{"school" => schoolId} -> schoolId
        _ -> "-1"
      end

    p =
      case params do
        %{"page" => p} -> p
        _ -> 1
      end

    index(conn, %{"page" => "#{p}", "school" => schoolId})
  end

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
    classList = UserAuth.getIds(conn, :classroom)
    {id, _} = Integer.parse(id)

    if id in classList do
      classroom = Classrooms.get_classroom!(id)
      students = Students.list_students_in_classroom(id)
      render(conn, "show.html", classroom: classroom, students: students)
    else
      conn
      |> put_flash(:error, Gettext.gettext("You dont have permission to see this page."))
      |> redirect(to: Routes.classroom_path(conn, :index))
      |> halt()
    end
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
