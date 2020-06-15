defmodule ScandocWeb.EmployeeLive.FormComponent do
  use ScandocWeb, :live_component

  alias Scandoc.Schools
  alias Scandoc.Classrooms
  alias Scandoc.Permissions
  alias Scandoc.Permissions.Permission

  alias Scandoc.Employees

  alias Scandoc.Permissions

  @impl true
  def update(%{employee: employee} = assigns, socket) do
    p_types = [
      %{id: Permissions.getLevelToInt(:allow_all), type: "ללא הגבלה"},
      %{id: Permissions.getLevelToInt(:allow_school), type: " הרשאת בית ספר"},
      %{id: Permissions.getLevelToInt(:allow_classroom), type: " הרשאת כיתה"},
      %{id: Permissions.getLevelToInt(:allow_student), type: " הרשאת תלמיד"},
      %{id: Permissions.getLevelToInt(:allow_institute), type: " הרשאת מוסד"},
      %{id: Permissions.getLevelToInt(:allow_vendor), type: " הרשאת ספק"}
    ]




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

    {
      :ok,
      socket
      |> assign(assigns)
      |> assign(roles: roles)
      |> assign(tabnum: 1)
      |> assign(permission_type: -1)
      |> assign(id: employee.id)
      |> assign(full_name: employee.full_name)
      |> assign(role: role)
      |> assign(school_id: school_id)
      |> assign(classroom_id: classroom_id)
      |> assign(schools: schools)
      |> assign(p_types: p_types)
      |> assign(classrooms: classrooms)
      |> assign(:changeset, changeset)
    }
  end

  @impl true
  def handle_event("validate", params, socket) do
    %{"employee" => employee_params} = params
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
    #    socket = assign(socket, )

    changeset =
      socket.assigns.employee
      |> Employees.change_employee(employee_params)
      |> Map.put(:action, :validate)


    {:noreply, assign(socket, changeset: changeset)}
  end

  @impl true
  def handle_event("setTab", %{"tabid" => tabnum}, socket) do
    {:noreply, assign(socket, tabnum: String.to_integer(tabnum))}
  end

  @impl true
  def handle_event("add-permission", _params, socket) do
    existing_permissions =
      Map.get(socket.assigns.changeset.changes, :permissions, socket.assigns.employee.permissions)
    permissions =
      existing_permissions
      |> Enum.concat(
           [
             # NOTE temp_id
             Permissions.change_permission(
               %Permission{
                 user_id: socket.assigns.employee.id,
                 temp_id: get_temp_id()
               }
             )
           ]
         )

    changeset =
      socket.assigns.changeset
      |> Ecto.Changeset.put_assoc(:permissions, permissions)
    {:noreply, assign(socket, changeset: changeset)}

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
      if classroom_id > 0 do
        classroom = Classrooms.get_classroom!(classroom_id)
        Classrooms.update_classroom(classroom, %{teacher_id: socket.assigns.employee.id})
      end
    end

    if isSchoolManager(role) do
      if school_id > 0 do
        school = Schools.get_school!(school_id)
        Schools.update_school(school, %{manager_id: socket.assigns.employee.id})
      end
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
      {:ok, employee} ->
        %{id: _id, zehut: _zehut} = employee
        {
          :noreply,
          socket
          |> push_redirect(to: socket.assigns.return_to)
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_employee(socket, :new, employee_params) do
    case Employees.create_employee(employee_params) do
      {:ok, _employee} ->
        {
          :noreply,
          socket
          |> push_redirect(to: socket.assigns.return_to)
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp get_temp_id,
       do:
         :crypto.strong_rand_bytes(5)
         |> Base.url_encode64()
         |> binary_part(0, 5)

end
