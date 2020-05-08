defmodule ScandocWeb.DocgroupLive.FormComponent do
  use ScandocWeb, :live_component

  alias Scandoc.Documents

  @impl true
  def update(%{docgroup: docgroup} = assigns, socket) do
    changeset = Documents.change_docgroup(docgroup)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"docgroup" => docgroup_params}, socket) do
    changeset =
      socket.assigns.docgroup
      |> Documents.change_docgroup(docgroup_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"docgroup" => docgroup_params}, socket) do
    save_docgroup(socket, socket.assigns.action, docgroup_params)
  end

  defp save_docgroup(socket, :edit, docgroup_params) do
    case Documents.update_docgroup(socket.assigns.docgroup, docgroup_params) do
      {:ok, _docgroup} ->
        {:noreply,
         socket
         |> put_flash(:info, "Docgroup updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_docgroup(socket, :new, docgroup_params) do
    case Documents.create_docgroup(docgroup_params) do
      {:ok, _docgroup} ->
        {:noreply,
         socket
         |> put_flash(:info, "Docgroup created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
