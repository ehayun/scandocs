defmodule ScandocWeb.DistrictLive.Index do
  use ScandocWeb, :live_view

  alias Scandoc.Tables
  alias Scandoc.Tables.District

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, search: "", districts: fetch_districts())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, gettext("Edit District"))
    |> assign(:district, Tables.get_district!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, gettext("New District"))
    |> assign(:district, %District{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, gettext("Listing Districts"))
    |> assign(:district, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    district = Tables.get_district!(id)
    {:ok, _} = Tables.delete_district(district)

    {:noreply, assign(socket, :districts, fetch_districts())}
  end

  defp fetch_districts do
    Tables.list_districts()
  end
end
