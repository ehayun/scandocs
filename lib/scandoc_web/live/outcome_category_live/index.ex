defmodule ScandocWeb.OutcomeCategoryLive.Index do
  use ScandocWeb, :live_view

  alias Scandoc.Categories
  alias Scandoc.Categories.OutcomeCategory

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :outcome_categoryes, fetch_outcome_categoryes())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, gettext("Edit Outcome category"))
    |> assign(:outcome_category, Categories.get_outcome_category!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, gettext("New Outcome category"))
    |> assign(:outcome_category, %OutcomeCategory{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, gettext("Listing Outcome categoryes"))
    |> assign(:outcome_category, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    outcome_category = Categories.get_outcome_category!(id)
    {:ok, _} = Categories.delete_outcome_category(outcome_category)

    {:noreply, assign(socket, :outcome_categoryes, fetch_outcome_categoryes())}
  end

  defp fetch_outcome_categoryes do
    Categories.list_outcome_categoryes()
  end
end
