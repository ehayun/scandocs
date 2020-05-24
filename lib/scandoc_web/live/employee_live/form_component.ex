defmodule ScandocWeb.EmployeeLive.FormComponent do
  use ScandocWeb, :live_component

  alias Scandoc.Employees
  alias Scandoc.Schools
  alias Scandoc.Classrooms

  @impl true
  def update(%{employee: employee} = assigns, socket) do
    {school_id, classroom_id} = Employees.get_classroom(employee.id)
    employee = Map.merge(employee, %{school_id: school_id, classroom_id: classroom_id})
    changeset = Employees.change_employee(employee)
    roles = Employees.list_roles()
    schools = Schools.list_schools()
    schools = List.insert_at(schools, 0, %{id: -1, school_name: gettext("Select school")})
    classrooms = Classrooms.list_classrooms(school_id)

    classrooms =
      List.insert_at(classrooms, 0, %{id: -1, classroom_name: gettext("Select classroom")})

    role = employee.role

    {:ok,
     socket
     |> assign(assigns)
     |> assign(roles: roles)
     |> assign(role: role)
     |> assign(school_id: school_id)
     |> assign(classroom_id: classroom_id)
     |> assign(schools: schools)
     |> assign(classrooms: classrooms)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"employee" => employee_params}, socket) do

    %{
      "role" => role
    } = employee_params

    school_id =
      case employee_params do
        %{"school_id" => school_id} -> school_id
        _ -> socket.assigns.school_id
      end

    classrooms = Classrooms.list_classrooms(school_id)

    classrooms =
      List.insert_at(classrooms, 0, %{id: -1, classroom_name: gettext("Select classroom")})

    socket = assign(socket, role: role, school_id: school_id, classrooms: classrooms)

    changeset =
      socket.assigns.employee
      |> Employees.change_employee(employee_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"employee" => employee_params}, socket) do
    %{"password" => password} = employee_params

    classroom_id =
      case employee_params do
        %{"classroom_id" => cr} -> String.to_integer(cr)
        _ -> nil
      end

    school_id =
      case employee_params do
        %{"school_id" => sc} -> String.to_integer(sc)
        _ -> nil
      end

    role =
      case employee_params do
        %{"role" => role} -> role
        _ -> ""
      end

    if isTeacher(role) do
      classroom = Classrooms.get_classroom!(classroom_id)
      Classrooms.update_classroom(classroom, %{teacher_id: socket.assigns.employee.id})
    end

    if isSchoolManager(role) do

      school = Schools.get_school!(school_id)
      Schools.update_school(school, %{manager_id: socket.assigns.employee.id})
    end

    employee_params =
      if password > "" do
        Map.merge(employee_params, %{"hashed_password" => Bcrypt.hash_pwd_salt(password)})
      else
        employee_params
      end

    save_employee(socket, socket.assigns.action, employee_params)
  end

  defp save_employee(socket, :edit, employee_params) do
    case Employees.update_employee(socket.assigns.employee, employee_params) do
      {:ok, _employee} ->
        {:noreply,
         socket
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_employee(socket, :new, employee_params) do
    case Employees.create_employee(employee_params) do
      {:ok, _employee} ->
        {:noreply,
         socket
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
