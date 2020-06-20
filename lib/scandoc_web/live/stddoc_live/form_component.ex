defmodule ScandocWeb.StddocLive.FormComponent do
  use ScandocWeb, :live_component

  alias Scandoc.Students
  alias Scandoc.Documents
  alias Scandoc.Documents.DocComments

  @impl true
  def update(assigns, socket) do
    %{stddoc: stddoc} = assigns
    changeset = Students.change_stddoc(stddoc)

    {
      :ok,
      socket
      |> assign(assigns)
      |> assign(:changeset, changeset)
    }
  end

  @impl true
  def handle_event("validate", %{"stddoc" => stddoc_params}, socket) do
    changeset =
      socket.assigns.stddoc
      |> Students.change_stddoc(stddoc_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  @impl true
  def handle_event("add-comment", _, socket) do
    existing_comments =
      Map.get(socket.assigns.changeset.changes, :comments, socket.assigns.stddoc.comments)

    comments =
      existing_comments
      |> Enum.concat(
           [
             Documents.change_stddoc_comment(
               %DocComments{
                 doc_name: socket.assigns.stddoc.doc_name,
                 temp_id: get_temp_id()
               }
             )
           ]
         )

    changeset =
      socket.assigns.changeset
      |> Ecto.Changeset.put_assoc(:comments, comments)


    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("remove-comment", %{"remove" => remove_id}, socket) do

    comments =
      socket.assigns.changeset.changes.comments
      |> Enum.reject(fn %{data: comment} ->
        comment.temp_id == remove_id
      end)

    changeset =
      socket.assigns.changeset
      |> Ecto.Changeset.put_assoc(:comments, comments)

    {:noreply, assign(socket, changeset: changeset)}
  end

  # =================================================================================
  def handle_event("close-doc", stddoc_params, socket) do
    # =================================================================================
    case Students.update_stddoc(socket.assigns.stddoc, stddoc_params) do
      {:ok, stddoc} ->
        student = Students.get_student!(stddoc.ref_id)
        {
          :noreply,
          socket
          |> push_redirect(to: Routes.stddoc_show_path(socket, :show, student, filter: "1"))
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp get_temp_id,
       do:
         :crypto.strong_rand_bytes(5)
         |> Base.url_encode64()
         |> binary_part(0, 5)

end
