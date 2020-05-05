defmodule ScandocWeb.StudentController do
  use ScandocWeb, :controller

  import Ecto.Query
  alias Scandoc.Repo

  alias Scandoc.Students
  alias Scandoc.Students.Student
  alias Scandoc.Documents.Document

  def index(conn, %{"page" => current_page}) do
    students =
      Student
      |> order_by(:full_name)
      |> preload(:classroom)
      |> Repo.paginate(page: current_page, page_size: 17)

    conn
    |> assign(:students, students)
    |> render("index.html")
  end

  def index(conn, _params), do: index(conn, %{"page" => "1"})

  def new(conn, _params) do
    changeset = Students.change_student(%Student{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"student" => student_params}) do
    case Students.create_student(student_params) do
      {:ok, student} ->
        conn
        |> put_flash(:info, "Student created successfully.")
        |> redirect(to: Routes.student_path(conn, :show, student))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    student = Students.get_student!(id)

    documents =
      Document
      |> preload(:doctype)
      |> where(ref_id: ^id)
      |> order_by(desc: :ref_year, desc: :ref_month)
      |> Repo.all()

    render(conn, "show.html", student: student, documents: documents)
  end

  def edit(conn, %{"id" => id}) do
    student = Students.get_student!(id)
    changeset = Students.change_student(student)
    render(conn, "edit.html", student: student, changeset: changeset)
  end

  def update(conn, %{"id" => id, "student" => student_params}) do
    student = Students.get_student!(id)

    case Students.update_student(student, student_params) do
      {:ok, student} ->
        conn
        |> put_flash(:info, "Student updated successfully.")
        |> redirect(to: Routes.student_path(conn, :show, student))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", student: student, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    student = Students.get_student!(id)
    {:ok, _student} = Students.delete_student(student)

    conn
    |> put_flash(:info, "Student deleted successfully.")
    |> redirect(to: Routes.student_path(conn, :index))
  end
end
