defmodule ScandocWeb.TransportationLive.FormComponent do
  use ScandocWeb, :live_component

  alias Scandoc.Tables

  @impl true
  def update(%{transportation: transportation} = assigns, socket) do
    changeset = Tables.change_transportation(transportation)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"transportation" => transportation_params}, socket) do
    changeset =
      socket.assigns.transportation
      |> Tables.change_transportation(transportation_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"transportation" => transportation_params}, socket) do
    save_transportation(socket, socket.assigns.action, transportation_params)
  end

  defp save_transportation(socket, :edit, transportation_params) do
    case Tables.update_transportation(socket.assigns.transportation, transportation_params) do
      {:ok, _transportation} ->
        {:noreply,
         socket
         |> put_flash(:info, gettext("Transportation updated successfully"))
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_transportation(socket, :new, transportation_params) do
    case Tables.create_transportation(transportation_params) do
      {:ok, _transportation} ->
        {:noreply,
         socket
         |> put_flash(:info, gettext("Transportation created successfully"))
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
