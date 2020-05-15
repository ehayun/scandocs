defmodule ScandocWeb.InstdocLive.Index do
  use ScandocWeb, :live_view

  alias Scandoc.Institutes
  alias Scandoc.Institutes.Instdoc

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :inst_docs, fetch_inst_docs())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Instdoc")
    |> assign(:instdoc, Institutes.get_instdoc!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Instdoc")
    |> assign(:instdoc, %Instdoc{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Inst docs")
    |> assign(:instdoc, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    instdoc = Institutes.get_instdoc!(id)
    {:ok, _} = Institutes.delete_instdoc(instdoc)

    {:noreply, assign(socket, :inst_docs, fetch_inst_docs())}
  end

  defp fetch_inst_docs do
    Institutes.list_inst_docs()
  end
end
