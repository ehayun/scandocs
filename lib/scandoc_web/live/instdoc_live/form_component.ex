defmodule ScandocWeb.InstdocLive.FormComponent do
  use ScandocWeb, :live_component

  alias Scandoc.Institutes

  @impl true
  def update(%{instdoc: instdoc} = assigns, socket) do
    changeset = Institutes.change_instdoc(instdoc)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"instdoc" => instdoc_params}, socket) do
    changeset =
      socket.assigns.instdoc
      |> Institutes.change_instdoc(instdoc_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"instdoc" => instdoc_params}, socket) do
    save_instdoc(socket, socket.assigns.action, instdoc_params)
  end

  defp save_instdoc(socket, :edit, instdoc_params) do
    case Institutes.update_instdoc(socket.assigns.instdoc, instdoc_params) do
      {:ok, _instdoc} ->
        {:noreply,
         socket
         |> put_flash(:info, "Instdoc updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_instdoc(socket, :new, instdoc_params) do
    case Institutes.create_instdoc(instdoc_params) do
      {:ok, _instdoc} ->
        {:noreply,
         socket
         |> put_flash(:info, "Instdoc created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
