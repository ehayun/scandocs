defmodule ScandocWeb.EmployeeLive.Index do
  use ScandocWeb, :live_view

  alias Scandoc.Employees
  alias Scandoc.Employees.Employee

  @impl true
  def mount(_params, _session, socket) do
    search = if socket.assigns[:search], do: socket.assigns[:search], else: ""
    roles = Employees.list_roles()
    {:ok, assign(socket, employees: fetch_employees(search), search: search, roles: roles)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    search = socket.assigns.search
    socket = socket |> assign(employees: fetch_employees(search))
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
    search = socket.assigns.search

    socket
    |> assign(:page_title, gettext("Listing Employees"))
    |> assign(search: search)
    |> assign(employees: fetch_employees(search))
    |> assign(:employee, nil)
  end

  @impl true
  def handle_event("search", %{"search" => search}, socket) do
    {:noreply, assign(socket, search: search, employees: fetch_employees(search))}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    employee = Employees.get_employee!(id)
    {:ok, _} = Employees.delete_employee(employee)
    search = ""

    {:noreply, assign(socket, :employees, fetch_employees(search))}
  end

  defp fetch_employees(search) do
    Employees.list_employees(search)
  end
end
