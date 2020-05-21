defmodule ScandocWeb.StudentLive.FormComponent do
  use ScandocWeb, :live_component

  alias Scandoc.Students
  alias Scandoc.Classrooms
  alias Scandoc.Schools

  @impl true
  def update(%{student: student} = assigns, socket) do
    classroom_id = if student.classroom_id, do: student.classroom_id, else: -1

    classroom = Classrooms.get_classroom!(classroom_id)
    school_id = if classroom, do: classroom.school_id, else: -1

    schools = Schools.list_schools()
    schools = List.insert_at(schools, 0, %{id: -1, school_name: gettext("Select school")})

    classrooms = Classrooms.list_classrooms(school_id)

    classrooms =
      List.insert_at(classrooms, 0, %{id: -1, classroom_name: gettext("Select classroom")})

    changeset = Students.change_student(student, %{school_id: school_id})

    {:ok,
     socket
     |> assign(assigns)
     |> assign(schools: schools)
     |> assign(school_id: school_id)
     |> assign(classrooms: classrooms)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"student" => student_params}, socket) do
    school_id =
      case student_params do
        %{"school_id" => school_id} -> school_id
        _ -> socket.assigns.school_id
      end

    classroom_id =
      case student_params do
        %{"classroom_id" => classroom_id} -> classroom_id
        _ -> socket.assigns.classroom_id
      end

    classrooms = Classrooms.list_classrooms(school_id)

    classrooms =
      List.insert_at(classrooms, 0, %{id: -1, classroom_name: gettext("Select classroom")})

    socket =
      assign(socket, school_id: school_id, classrooms: classrooms, classroom_id: classroom_id)

    changeset =
      socket.assigns.student
      |> Students.change_student(student_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"student" => student_params}, socket) do
    IO.inspect(student_params)
    save_student(socket, socket.assigns.action, student_params)
  end

  defp save_student(socket, :edit, student_params) do
    case Students.update_student(socket.assigns.student, student_params) do
      {:ok, _student} ->
        {:noreply,
         socket
         |> put_flash(:info, "Student updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_student(socket, :new, student_params) do
    case Students.create_student(student_params) do
      {:ok, _student} ->
        {:noreply,
         socket
         |> put_flash(:info, "Student created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
