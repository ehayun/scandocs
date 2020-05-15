defmodule ScandocWeb.DocgroupLive.Index do
  use ScandocWeb, :live_view

  alias Scandoc.Documents
  alias Scandoc.Documents.Docgroup

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :docgroups, fetch_docgroups())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, gettext("Edit Docgroup"))
    |> assign(:docgroup, Documents.get_docgroup!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, gettext("New Docgroup"))
    |> assign(:docgroup, %Docgroup{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, gettext("Listing Docgroups"))
    |> assign(:docgroup, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    docgroup = Documents.get_docgroup!(id)
    {:ok, _} = Documents.delete_docgroup(docgroup)

    {:noreply, assign(socket, :docgroups, fetch_docgroups())}
  end

  defp fetch_docgroups do
    Documents.list_docgroups()
  end
end
