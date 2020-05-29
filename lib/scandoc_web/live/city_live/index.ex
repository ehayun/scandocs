defmodule ScandocWeb.CityLive.Index do
  use ScandocWeb, :live_view

  alias Scandoc.Tables
  alias Scandoc.Tables.City

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, search: "", cities: fetch_cities())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, gettext("Edit City"))
    |> assign(:city, Tables.get_city!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, gettext("New City"))
    |> assign(:city, %City{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, gettext("Listing Cities"))
    |> assign(:city, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    city = Tables.get_city!(id)
    {:ok, _} = Tables.delete_city(city)

    {:noreply, assign(socket, :cities, fetch_cities())}
  end

  defp fetch_cities do
    Tables.list_cities(15)
  end
end
