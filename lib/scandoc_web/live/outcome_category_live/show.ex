defmodule ScandocWeb.OutcomeCategoryLive.Show do
  use ScandocWeb, :live_view

  alias Scandoc.Categories

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:outcome_category, Categories.get_outcome_category!(id))}
  end

  defp page_title(:show), do: "Show Outcome category"
  defp page_title(:edit), do: "Edit Outcome category"
end
