defmodule ScandocWeb.EmployeeLive.FormComponent do
  use ScandocWeb, :live_component

  import Ecto.Query
  alias Scandoc.Repo

  alias Scandoc.Accounts.User
  alias Scandoc.Schools.School
  alias Scandoc.Classrooms
  alias Scandoc.Students.Student
  alias Scandoc.Institutes.Institute
  alias Scandoc.Vendors.Vendor

  alias Scandoc.Employees
  alias Scandoc.Schools
  alias Scandoc.Classrooms.Classroom


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


    uQ = from u in User, where: u.role != "000", select: [:id, :full_name], order_by: u.full_name
    users = uQ
            |> Repo.all()

    sQ = from u in School, select: [:id, :school_name]
    schools = sQ
              |> Repo.all()

    stdQ = from u in Student, select: [:id, :full_name, :student_zehut]
    students = stdQ
               |> Repo.all()

    instQ = from u in Institute, select: [:id, :code, :title]
    institutes = instQ
                 |> Repo.all()

    vendQ = from u in Vendor, select: [:id, :vendor_name, :contact_name]
    vendors = vendQ
              |> Repo.all()

    s = schools
        |> hd

    sid =
      case s do
        nil -> -1
        _ -> s.id
      end

    cQ = Classroom
         |> where(school_id: ^sid)

    classrooms = cQ
                 |> Repo.all()

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

    IO.inspect(changeset.changes, label: "xxx")
    cs = case changeset.changes do
      %{
        permissions: permissions
      } -> permissions
           IO.inspect("perm")
           permissions
           |> hd
      res -> IO.inspect(res, label: "res")
             nil
    end

    pt = if cs do
      IO.inspect(cs.changes, label: "ggg")
      case cs.changes do
        %{permission_type: pt} -> pt
        _ -> 1
      end
    else
      -1
    end

    {:noreply, assign(socket, changeset: changeset, permission_type: pt)}
  end

  @impl true
  def handle_event("setTab", %{"tabid" => tabnum}, socket) do
    {:noreply, assign(socket, tabnum: String.to_integer(tabnum))}
  end

  @impl true
  def handle_event("add-permission", _params, socket) do
    {:noreply, socket}
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
      {:ok, _employee} ->
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
end
