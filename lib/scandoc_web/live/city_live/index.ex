defmodule ScandocWeb.CityLive.Index do
  use ScandocWeb, :live_view

  alias Scandoc.Tables
  alias Scandoc.Tables.City

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, search: "", cities: fetch_cities(socket))}
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

    {:noreply, assign(socket, :cities, fetch_cities(socket))}
  end

  @impl true
  def handle_event("search", %{"search" => search}, socket) do
    socket = assign(socket, search: search)
    {:noreply, assign(socket, search: search, cities: fetch_cities(socket))}
  end

  @impl true
  def handle_event("nav", %{"page" => page}, socket) do
    socket = assign(socket, current_page: String.to_integer(page))
    {:noreply, assign(socket, :cities, fetch_cities(socket))}
  end

  defp fetch_cities(socket) do
    current_page = if socket.assigns[:current_page], do: socket.assigns[:current_page], else: 1
    search = if socket.assigns[:search], do: socket.assigns[:search], else: ""
    Tables.list_cities(15, current_page, search)
  end
end
