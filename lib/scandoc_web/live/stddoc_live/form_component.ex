defmodule ScandocWeb.StddocLive.FormComponent do
  use ScandocWeb, :live_component

  alias Scandoc.Students

  @impl true
  def update(assigns, socket) do
    %{stddoc: stddoc} = assigns
    changeset = Students.change_stddoc(stddoc)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  # def notupdate(%{stddoc: stddoc} = assigns, socket) do
  # end

  @impl true
  def handle_event("validate", %{"stddoc" => stddoc_params}, socket) do
    changeset =
      socket.assigns.stddoc
      |> Students.change_stddoc(stddoc_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  # =================================================================================
  def handle_event("close-doc", params, socket) do
    # =================================================================================
    student =
      case params do
        %{"stddoc" => %{"ref_id" => student}} -> Students.get_student!(student)
        _ -> 290
      end

    {:noreply,
     push_patch(socket,
       student: student,
       to: Routes.stddoc_show_path(socket, :show, student)
     )}
  end
end
