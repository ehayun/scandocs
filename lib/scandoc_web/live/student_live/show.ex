defmodule ScandocWeb.StudentLive.Show do
  use ScandocWeb, :live_view

  alias Scandoc.Students
  alias Scandoc.Documents

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, sort_by: nil, pdf_id: nil, doc_path: nil)}
  end

  @impl true
  @spec handle_params(map, any, Phoenix.LiveView.Socket.t()) ::
          {:noreply, Phoenix.LiveView.Socket.t()}
  def handle_params(%{"id" => id}, _, socket) do
    documents = Documents.list_student_documents(id)
    docgroups = Documents.list_student_docgroups()

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:student, Students.get_student!(id))
     |> assign(:display, false)
     |> assign(:documents, documents)
     |> assign(:docgroups, docgroups)}
  end

  @impl true
  def handle_event("sort_by", %{"id" => id}, socket) do
    id =
      case id do
        "" -> nil
        id -> String.to_integer(id)
      end

    documents = Documents.list_student_documents(socket.assigns.student.id, id)

    {:noreply, assign(socket, sort_by: id, documents: documents)}
  end

  @impl true
  def handle_event("show-pdf", %{"id" => id}, socket) do
    id =
      case id do
        "" -> nil
        id -> String.to_integer(id)
      end

    if id do
      document = Documents.get_document!(id)

      if document do
        path = document.doc_path
        path = String.replace(path, "/home/eli", "/downloads")

        if File.exists?(".#{path}") do
          doc_name = Path.basename(path)

          just_name = Path.rootname(doc_name)

          png =
            case pdf_thumbnail(".#{path}", "./priv/static//uploads/#{just_name}.png") do
              {:ok, png} ->
                doc_name = Path.basename(png)
                Path.rootname(doc_name)

              _ ->
                nil
            end

          {:noreply, assign(socket, pdf_id: id, display: true, doc_path: png)}
        else
          {:noreply, assign(socket, pdf_id: id)}
        end
      else
        {:noreply, assign(socket, pdf_id: id)}
      end
    else
      {:noreply, socket}
    end
  end

  def handle_event("close-modal", _, socket) do
    {:noreply, assign(socket, display: false)}
  end

  defp pdf_thumbnail(pdf_path, thumb_path) do
    args = ["#{pdf_path}", thumb_path]
    name = Path.rootname(thumb_path)

    if File.exists?("#{name}.png") || File.exists?("#{name}-0.png") do
      {:ok, thumb_path}
    else
      result =
        case System.cmd("convert", args, stderr_to_stdout: true) do
          {_, 0} -> {:ok, thumb_path}
          {reason, _} -> {:error, reason}
        end

      # :timer.sleep(300)
      result
    end
  end

  defp page_title(:show), do: gettext("Show Student")
  defp page_title(:edit), do: gettext("Edit Student")
end
