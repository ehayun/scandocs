defmodule ScandocWeb.TransportationLive.Index do
  use ScandocWeb, :live_view

  alias Scandoc.Tables
  alias Scandoc.Tables.Transportation

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, search: "", transportations: fetch_transportations())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, gettext("Edit Transportation"))
    |> assign(:transportation, Tables.get_transportation!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, gettext("New Transportation"))
    |> assign(:transportation, %Transportation{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, gettext("Listing Tansportations"))
    |> assign(:transportation, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    transportation = Tables.get_transportation!(id)
    {:ok, _} = Tables.delete_transportation(transportation)

    {:noreply, assign(socket, :transportations, fetch_transportations())}
  end

  defp fetch_transportations do
    Tables.list_transportations(15)
  end
end
