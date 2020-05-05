defmodule ScandocWeb.PermissionLive.Index do
  use ScandocWeb, :live_view

  import Ecto.Query
  alias Scandoc.Repo

  alias Scandoc.Permissions
  alias Scandoc.Permissions.Permission

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:startEdit, 0)
     |> assign(:permissions, fetch_permissions())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, gettext("Edit Permission"))
    |> assign(:permission, Permissions.get_permission!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, gettext("New Permission"))
    |> assign(:permission, %Permission{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, gettext("Listing Permissions"))
    |> assign(:permission, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    permission = Permissions.get_permission!(id)
    {:ok, _} = Permissions.delete_permission(permission)

    {:noreply, assign(socket, :permissions, fetch_permissions())}
  end

  def handle_event("startEdit", %{"id" => id}, socket) do
    {:noreply, assign(socket, :startEdit, String.to_integer(id))}
  end

  defp fetch_permissions do
    # Permissions.list_permissions()
    Permission
    |> preload(:user)
    |> order_by(:user_id)
    |> Repo.all()
  end
end
