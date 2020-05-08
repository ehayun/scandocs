defmodule ScandocWeb.DocgroupLive.Show do
  use ScandocWeb, :live_view

  alias Scandoc.Documents

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:docgroup, Documents.get_docgroup!(id))}
  end

  defp page_title(:show), do: "Show Docgroup"
  defp page_title(:edit), do: "Edit Docgroup"
end
