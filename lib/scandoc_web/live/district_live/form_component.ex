defmodule ScandocWeb.DistrictLive.FormComponent do
  use ScandocWeb, :live_component

  alias Scandoc.Tables

  @impl true
  def update(%{district: district} = assigns, socket) do
    changeset = Tables.change_district(district)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"district" => district_params}, socket) do
    changeset =
      socket.assigns.district
      |> Tables.change_district(district_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"district" => district_params}, socket) do
    save_district(socket, socket.assigns.action, district_params)
  end

  defp save_district(socket, :edit, district_params) do
    case Tables.update_district(socket.assigns.district, district_params) do
      {:ok, _district} ->
        {:noreply,
         socket
         |> put_flash(:info, gettext("District updated successfully"))
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_district(socket, :new, district_params) do
    case Tables.create_district(district_params) do
      {:ok, _district} ->
        {:noreply,
         socket
         |> put_flash(:info, gettext("District created successfully"))
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
