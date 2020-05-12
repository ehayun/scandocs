defmodule ScandocWeb.PermissionLive.FormComponent do
  use ScandocWeb, :live_component

  import Ecto.Query
  alias Scandoc.Repo

  alias Scandoc.Permissions
  # alias Scandoc.Accounts
  alias Scandoc.Accounts.User
  alias Scandoc.Schools.School
  alias Scandoc.Students.Student
  alias Scandoc.Classrooms.Classroom

  @impl true
  def update(%{permission: permission} = assigns, socket) do
    changeset = Permissions.change_permission(permission)

    p_types = [
      %{id: 0, type: "ללא הגבלה"},
      %{id: 1, type: " הרשאת בית ספר"},
      %{id: 2, type: " הרשאת כיתה"},
      %{id: 3, type: " הרשאת תלמיד"}
    ]

    permission_type = permission.permission_type
    ref_id = permission.ref_id

    uQ = from u in User, where: u.role != "000", select: [:id, :full_name], order_by: u.full_name
    users = uQ |> Repo.all()

    sQ = from u in School, select: [:id, :school_name]
    schools = sQ |> Repo.all()

    stdQ = from u in Student, select: [:id, :full_name, :student_zehut]
    students = stdQ |> Repo.all()

    s = schools |> Enum.at(0)

    sid =
      case s do
        nil -> -1
        _ -> s.id
      end

    cQ = Classroom |> where(school_id: ^sid)
    classrooms = cQ |> Repo.all()

    socket = assign(socket, users: users, schools: schools, students: students)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:user_id, permission.user_id)
     |> assign(p_types: p_types)
     |> assign(permission_type: permission_type)
     |> assign(classrooms: classrooms)
     |> assign(ref_id: ref_id)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"permission" => permission_params}, socket) do
    permission_type =
      case permission_params do
        %{"permission_type" => pt} -> String.to_integer(pt)
        _ -> nil
      end

    ref_id =
      case permission_params do
        %{"ref_id" => rid} -> String.to_integer(rid)
        _ -> 0
      end

    school_id =
      case permission_params do
        %{"school_id" => sid} ->
          String.to_integer(sid)

        _ ->
          -1
      end

    classrooms =
      if school_id > 0 do
        cQ = Classroom |> where(school_id: ^school_id)
        cQ |> Repo.all()
      else
        socket.assigns.classrooms
      end

    changeset =
      socket.assigns.permission
      |> Permissions.change_permission(permission_params)
      |> Map.put(:action, :validate)

    {:noreply,
     socket
     |> assign(:changeset, changeset)
     |> assign(permission_type: permission_type)
     |> assign(classrooms: classrooms)
     |> assign(ref_id: ref_id)}
  end

  def handle_event("save", %{"permission" => permission_params}, socket) do
    save_permission(socket, socket.assigns.action, permission_params)
  end

  def handle_event("updatePermissionType", _params, socket) do
    {:noreply, socket}
  end

  defp save_permission(socket, :edit, permission_params) do
    case Permissions.update_permission(socket.assigns.permission, permission_params) do
      {:ok, _permission} ->
        {:noreply,
         socket
         |> put_flash(:info, gettext("Permission updated successfully"))
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_permission(socket, :new, permission_params) do
    case Permissions.create_permission(permission_params) do
      {:ok, _permission} ->
        {:noreply,
         socket
         |> put_flash(:info, gettext("Permission created successfully"))
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
