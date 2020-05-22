defmodule ScandocWeb.TeacherController do
  use ScandocWeb, :controller

  alias Scandoc.Schools
  alias Scandoc.Schools.Teacher
  alias Scandoc.Classrooms.Classroom
  import Ecto.Query

  alias Scandoc.Repo

  def index(conn, %{"page" => current_page, "school" => schoolId}) do
    schoolId = String.to_integer(schoolId)

    teachers_order_query = from(t in Teacher, where: t.role == "030", order_by: t.full_name)

    # r = teachers_order_query |> Repo.all()
    # IO.inspect(r)

    q =
      if schoolId > 0 do
        Classroom |> where(school_id: ^schoolId)
      else
        Classroom
      end

    q = q |> preload(teacher: ^teachers_order_query) |> preload(:school)

    classrooms =
      q
      |> Repo.paginate(page: current_page, page_size: 15)

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

    %{"password" => password} = teacher_params

    teacher_params =
      if password > "" do
        Map.merge(teacher_params, %{"hashed_password" => Bcrypt.hash_pwd_salt(password)})
      else
        teacher_params
      end

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
