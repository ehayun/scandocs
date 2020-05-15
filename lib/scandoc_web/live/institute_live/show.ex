defmodule ScandocWeb.InstituteLive.Show do
  use ScandocWeb, :live_view

  alias Scandoc.Institutes

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:institute, Institutes.get_institute!(id))}
  end

  defp page_title(:show), do: "Show Institute"
  defp page_title(:edit), do: "Edit Institute"
end
