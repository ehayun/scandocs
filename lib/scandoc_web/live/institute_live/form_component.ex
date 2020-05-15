defmodule ScandocWeb.InstituteLive.FormComponent do
  use ScandocWeb, :live_component

  alias Scandoc.Institutes

  @impl true
  def update(%{institute: institute} = assigns, socket) do
    changeset = Institutes.change_institute(institute)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"institute" => institute_params}, socket) do
    changeset =
      socket.assigns.institute
      |> Institutes.change_institute(institute_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"institute" => institute_params}, socket) do
    save_institute(socket, socket.assigns.action, institute_params)
  end

  defp save_institute(socket, :edit, institute_params) do
    case Institutes.update_institute(socket.assigns.institute, institute_params) do
      {:ok, _institute} ->
        {:noreply,
         socket
         |> put_flash(:info, "Institute updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_institute(socket, :new, institute_params) do
    case Institutes.create_institute(institute_params) do
      {:ok, _institute} ->
        {:noreply,
         socket
         |> put_flash(:info, "Institute created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
