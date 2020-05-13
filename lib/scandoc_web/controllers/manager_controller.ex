defmodule ScandocWeb.ManagerController do
  use ScandocWeb, :controller

  alias Scandoc.Schools
  alias Scandoc.Schools.Manager

  def index(conn, _params) do
    schools = Schools.list_managers()
    render(conn, "index.html", schools: schools)
  end

  def new(conn, _params) do
    changeset = Schools.change_manager(%Manager{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"manager" => manager_params}) do
    case Schools.create_manager(manager_params) do
      {:ok, manager} ->
        conn
        |> put_flash(:info, "Manager created successfully.")
        |> redirect(to: Routes.manager_path(conn, :show, manager))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    manager = Schools.get_manager!(id)
    render(conn, "show.html", manager: manager)
  end

  def edit(conn, %{"id" => id}) do
    manager = Schools.get_manager!(id)
    changeset = Schools.change_manager(manager)
    render(conn, "edit.html", manager: manager, changeset: changeset)
  end

  def update(conn, %{"id" => id, "manager" => manager_params}) do
    manager = Schools.get_manager!(id)

    case Schools.update_manager(manager, manager_params) do
      {:ok, manager} ->
        conn
        |> put_flash(:info, "Manager updated successfully.")
        |> redirect(to: Routes.manager_path(conn, :show, manager))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", manager: manager, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    manager = Schools.get_manager!(id)
    {:ok, _manager} = Schools.delete_manager(manager)

    conn
    |> put_flash(:info, "Manager deleted successfully.")
    |> redirect(to: Routes.manager_path(conn, :index))
  end
end
