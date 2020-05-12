defmodule ScandocWeb.StddocLive.Show do
  use ScandocWeb, :live_view

  alias Scandoc.Students

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:stddoc, Students.get_stddoc!(id))}
  end

  defp page_title(:show), do: "Show Stddoc"
  defp page_title(:edit), do: "Edit Stddoc"
end
