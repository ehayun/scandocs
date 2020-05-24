defmodule ScandocWeb.ClassroomController do
  use ScandocWeb, :controller

  import Ecto.Query
  alias Scandoc.Repo

  alias Scandoc.Schools
  alias Scandoc.Schools.Teacher
  alias Scandoc.Classrooms
  alias Scandoc.Students
  alias Scandoc.Classrooms.Classroom

  alias ScandocWeb.UserAuth

  def index(conn, %{"page" => current_page, "search" => search, "school" => schoolId}) do
    # classrooms = Classrooms.list_classrooms()
    # render(conn, "index.html", classrooms: classrooms)
    classList = UserAuth.getIds(conn, :classroom)
    schoolId = String.to_integer(schoolId)

    teachers =
      if search > "" do
        from(t in Teacher, where: ilike(t.full_name, ^"%#{search}%"))
        |> Repo.all()
        |> Enum.map(fn u -> u.id end)
      else
        []
      end

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

    q =
      if search > "" do
        from(c in q, where: ilike(c.classroom_name, ^"%#{search}%") or c.teacher_id in ^teachers)
      else
        q
      end

    classrooms =
      q
      |> order_by(:school_id)
      |> order_by(:classroom_name)
      |> preload(:school)
      |> preload(:teacher)
      |> Repo.paginate(page: current_page, page_size: 15)

    teachers = Schools.list_teachers()

    conn
    |> assign(:classrooms, classrooms)
    |> assign(:teachers, teachers)
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

    search =
      case params do
        %{"search" => p} -> p
        _ -> ""
      end

    index(conn, %{"page" => "#{p}", "search" => "#{search}", "school" => schoolId})
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

    IO.inspect(classList, label: "classes in [#{id}]")

    if id in classList || UserAuth.isAdmin(conn) do
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
    teachers = Schools.list_teachers()

    classroom = Classrooms.get_classroom!(id)
    changeset = Classrooms.change_classroom(classroom)
    render(conn, "edit.html", classroom: classroom, changeset: changeset, teachers: teachers)
  end

  def update(conn, %{"id" => id, "classroom" => classroom_params}) do
    classroom = Classrooms.get_classroom!(id)

    case Classrooms.update_classroom(classroom, classroom_params) do
      {:ok, _classroom} ->
        conn
        # |> put_flash(:info, "Classroom updated successfully.")
        |> redirect(to: Routes.classroom_path(conn, :index))

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
