defmodule ScandocWeb.CategoryLive.Index do
  use ScandocWeb, :live_view

  alias Scandoc.Categories
  alias Scandoc.Categories.Category

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :categories, fetch_categories())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, gettext("Edit Category"))
    |> assign(:category, Categories.get_category!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, gettext("New Category"))
    |> assign(:category, %Category{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, gettext("Listing Categories"))
    |> assign(:category, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    category = Categories.get_category!(id)
    {:ok, _} = Categories.delete_category(category)

    {:noreply, assign(socket, :categories, fetch_categories())}
  end

  defp fetch_categories do
    Categories.list_categories()
  end
end