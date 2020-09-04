defmodule ScandocWeb.StudentLive.FormComponent do
  use ScandocWeb, :live_component

  alias Scandoc.Students
  alias Scandoc.Students.StudentComment
  alias Scandoc.Classrooms
  alias Scandoc.Schools
  alias Scandoc.Tables

  @impl true
  def update(%{student: student} = assigns, socket) do
    tabnum = if socket.assigns[:tabnum], do: socket.assigns[:tabnum], else: 4
    cities = Tables.list_cities()
    genders = Tables.list_gender()

    healthcares = Tables.list_healthcare()

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
     |> assign(tabnum: tabnum)
     |> assign(cities: cities)
     |> assign(genders: genders)
     |> assign(healthcares: healthcares)
     |> assign(schools: schools)
     |> assign(school_id: school_id)
     |> assign(classrooms: classrooms)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("setTab", %{"tabid" => tabnum}, socket) do
    {:noreply, assign(socket, tabnum: String.to_integer(tabnum))}
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

  @impl true
  def handle_event("save", %{"student" => student_params}, socket) do
    save_student(socket, socket.assigns.action, student_params)
  end

  @impl true
  def handle_event("add-comment", _student_params, socket) do
    existing_comments =
      Map.get(socket.assigns.changeset.changes, :comments, socket.assigns.student.comments)

    comments =
      existing_comments
      |> Enum.concat([
        # NOTE temp_id
        Students.change_student_comment(%StudentComment{
          student_id: socket.assigns.student.id,
          comment: "",
          temp_id: get_temp_id()
        })
      ])

    changeset =
      socket.assigns.changeset
      |> Ecto.Changeset.put_assoc(:comments, comments)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, changeset: changeset)}
  end

  defp get_temp_id, do: :crypto.strong_rand_bytes(5) |> Base.url_encode64() |> binary_part(0, 5)

  defp save_student(socket, :edit, student_params) do
    %{
      "first_name" => first,
      "last_name" => last
    } = student_params

    Map.merge(student_params, %{"full_name" => "#{last} #{first}"})


    student_params =
      case student_params do
        %{"birthdate" => %{"day" => _dd, "month" => _mm, "year" => yy}} ->
          if String.to_integer(yy) < 1995 do
            Map.merge(student_params, %{
              "birthdate" => %{"day" => "0", "month" => "0", "year" => "0"}
            })
          else
            student_params
          end

        student_params ->
          student_params
      end


    case Students.update_student(socket.assigns.student, student_params) do
      {:ok, _student} ->
        {:noreply,
         socket
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
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
