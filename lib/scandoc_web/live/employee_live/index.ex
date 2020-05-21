defmodule ScandocWeb.EmployeeLive.Index do
  use ScandocWeb, :live_view

  alias Scandoc.Employees
  alias Scandoc.Employees.Employee

  @impl true
  def mount(_params, _session, socket) do
    current_page = if socket.assigns[:current_page], do: socket.assigns[:current_page], else: 1

    search = if socket.assigns[:search], do: socket.assigns[:search], else: ""
    roles = Employees.list_roles()

    socket =
      assign(socket,
        current_page: current_page,
        search: search,
        roles: roles
      )

    {:ok,
     assign(socket,
       employees: fetch_employees(socket)
     )}
  end

  @impl true
  def handle_params(params, _url, socket) do
    current_page =
      case params do
        %{"page" => page} -> page
        _ -> socket.assigns.current_page
      end

    socket = assign(socket, current_page: current_page)

    socket = socket |> assign(employees: fetch_employees(socket))
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, gettext("Edit Employee"))
    |> assign(:employee, Employees.get_employee!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, gettext("New Employee"))
    |> assign(:employee, %Employee{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, gettext("Listing Employees"))
    |> assign(employees: fetch_employees(socket))
    |> assign(:employee, nil)
  end

  @impl true
  def handle_event("search", %{"search" => search}, socket) do
    socket = assign(socket, search: search)
    {:noreply, assign(socket, search: search, employees: fetch_employees(socket))}
  end

  @impl true
  def handle_event("nav", %{"page" => page}, socket) do
    socket = assign(socket, current_page: String.to_integer(page))
    {:noreply, assign(socket, employees: fetch_employees(socket))}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    employee = Employees.get_employee!(id)
    {:ok, _} = Employees.delete_employee(employee)

    {:noreply, assign(socket, :employees, fetch_employees(socket))}
  end

  defp fetch_employees(socket) do
    search = socket.assigns.search

    Employees.list_employees(17, socket.assigns.current_page, search)
  end
end
