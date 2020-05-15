defmodule ScandocWeb.InstituteLive.Index do
  use ScandocWeb, :live_view

  alias Scandoc.Institutes
  alias Scandoc.Institutes.Institute

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :institutes, fetch_institutes())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, gettext("Edit Institute"))
    |> assign(:institute, Institutes.get_institute!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, gettext("New Institute"))
    |> assign(:institute, %Institute{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, gettext("Listing Institutes"))
    |> assign(:institute, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    institute = Institutes.get_institute!(id)
    {:ok, _} = Institutes.delete_institute(institute)

    {:noreply, assign(socket, :institutes, fetch_institutes())}
  end

  defp fetch_institutes do
    Institutes.list_institutes()
  end
end
