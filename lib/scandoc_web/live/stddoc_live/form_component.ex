defmodule ScandocWeb.StddocLive.FormComponent do
  use ScandocWeb, :live_component

  alias Scandoc.Students

  @impl true
  def update(%{stddoc: stddoc} = assigns, socket) do
    changeset = Students.change_stddoc(stddoc)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"stddoc" => stddoc_params}, socket) do
    changeset =
      socket.assigns.stddoc
      |> Students.change_stddoc(stddoc_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("close-doc", params, socket) do
    IO.inspect(socket.assigns)

    student =
      case params do
        %{"stddoc" => %{"ref_id" => student}} -> student
        _ -> 290
      end

    {:noreply, push_patch(socket, student: student, to: socket.assigns.return_to)}
    # {:noreply,
    #  socket
    #  |> push_redirect(to: Routes.stddoc_index_path(socket, :index, student: student))}
  end
end
