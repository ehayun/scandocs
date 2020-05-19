defmodule ScandocWeb.InstdocLive.Index do
  use ScandocWeb, :live_view

  alias Scandoc.Institutes
  # alias Scandoc.Institutes.Institute
  alias Scandoc.Categories
  alias Scandoc.Institutes
  alias Scandoc.Institutes.Instdoc

  @impl true
  def mount(_params, _session, socket) do
    changeset = Institutes.change_instdoc(%Instdoc{})

    filter = %{
      "category" => "-1",
      "institute" => "-1",
      "outcome_category" => "-1",
      "vendor_name" => ""
    }

    socket =
      assign(socket,
        filter: filter,
        by_category: "-1",
        by_outcome_category: "-1",
        by_institute: "-1",
        vendor_name: ""
      )

    {:ok,
     assign(socket,
       inst_docs: fetch_inst_docs(socket),
       categories: fetch_categories(),
       institutes: fetch_institutes(),
       outcome_categories: fetch_outcome_categories(),
       changeset: changeset
     )}
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
  def handle_event("filter", params, socket) do
    %{"filter" => filter} = params

    %{
      "category" => by_category,
      "institute" => by_institute,
      "outcome_category" => by_outcome_category,
      "vendor_name" => vendor_name
    } = filter

    socket =
      assign(socket,
        filter: filter,
        by_category: by_category,
        by_outcome_category: by_outcome_category,
        by_institute: by_institute,
        vendor_name: vendor_name
      )

    {:noreply, assign(socket, :inst_docs, fetch_inst_docs(socket))}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    instdoc = Institutes.get_instdoc!(id)
    {:ok, _} = Institutes.delete_instdoc(instdoc)

    {:noreply, assign(socket, :inst_docs, fetch_inst_docs(socket))}
  end

  defp fetch_inst_docs(socket) do
    filter = socket.assigns.filter

    Institutes.list_inst_docs(17, filter)
  end

  defp fetch_categories do
    Categories.list_categories()
  end

  def fetch_outcome_categories do
    Categories.list_outcome_categoryes()
  end

  def fetch_institutes do
    Institutes.list_institutes()
  end
end
