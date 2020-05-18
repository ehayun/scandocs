defmodule ScandocWeb.EmployeeLive.FormComponent do
  use ScandocWeb, :live_component

  alias Scandoc.Employees

  @impl true
  def update(%{employee: employee} = assigns, socket) do
    changeset = Employees.change_employee(employee)
    roles = Employees.list_roles()

    {:ok,
     socket
     |> assign(assigns)
     |> assign(roles: roles)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"employee" => employee_params}, socket) do
    changeset =
      socket.assigns.employee
      |> Employees.change_employee(employee_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"employee" => employee_params}, socket) do
    %{"password" => password} = employee_params

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
         |> put_flash(:info, gettext("Employee updated successfully"))
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
         |> put_flash(:info, gettext("Employee created successfully"))
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
