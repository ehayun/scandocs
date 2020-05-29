defmodule ScandocWeb.DistrictLive.Show do
  use ScandocWeb, :live_view

  alias Scandoc.Tables

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:district, Tables.get_district!(id))}
  end

  defp page_title(:show), do: "Show District"
  defp page_title(:edit), do: "Edit District"
end
