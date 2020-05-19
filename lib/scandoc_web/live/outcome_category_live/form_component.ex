defmodule ScandocWeb.OutcomeCategoryLive.FormComponent do
  use ScandocWeb, :live_component

  alias Scandoc.Categories

  @impl true
  def update(%{outcome_category: outcome_category} = assigns, socket) do
    changeset = Categories.change_outcome_category(outcome_category)

    categories = Categories.list_categories()

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:categories, categories)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"outcome_category" => outcome_category_params}, socket) do
    changeset =
      socket.assigns.outcome_category
      |> Categories.change_outcome_category(outcome_category_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"outcome_category" => outcome_category_params}, socket) do
    save_outcome_category(socket, socket.assigns.action, outcome_category_params)
  end

  defp save_outcome_category(socket, :edit, outcome_category_params) do
    case Categories.update_outcome_category(
           socket.assigns.outcome_category,
           outcome_category_params
         ) do
      {:ok, _outcome_category} ->
        {:noreply,
         socket
         |> put_flash(:info, "Outcome category updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_outcome_category(socket, :new, outcome_category_params) do
    case Categories.create_outcome_category(outcome_category_params) do
      {:ok, _outcome_category} ->
        {:noreply,
         socket
         |> put_flash(:info, "Outcome category created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
