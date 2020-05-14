defmodule ScandocWeb.StddocLive.Show do
  use ScandocWeb, :live_view

  alias Scandoc.Students

  alias Scandoc.Documents
  alias Scandoc.Students.Stddoc

  @impl true
  def mount(_params, _session, socket) do
    docgroups = Documents.list_student_docgroups()

    {:ok, assign(socket, docgroups: docgroups, filter_by: nil, search: "")}
  end

  @impl true
  def handle_params(params, _session, socket) do
    # def handle_params(%{"id" => id}, _, socket) do

    filter_by = socket.assigns.filter_by
    search = socket.assigns.search
    %{"id" => id} = params

    {id, _} = Integer.parse(id)

    student =
      if socket.assigns[:student] do
        socket.assigns.student
      else
        Students.get_student!(id)
      end

    stddoc =
      if id != student.id do
        Students.get_stddoc!(id)
      else
        case params do
          %{"docnum" => docnum} -> Students.get_stddoc!(docnum)
          _ -> nil
        end
      end

    if stddoc do
      path = stddoc.doc_path
      path = String.replace(path, "/home/eli", "/downloads")

      IO.inspect(path, label: "search for")

      png =
        if File.exists?(".#{path}") do
          doc_name = Path.basename(path)

          just_name = Path.rootname(doc_name)

          upload_path = Application.get_env(:scandoc, :full_upload_path)

          case pdf_thumbnail(".#{path}", "#{upload_path}/#{just_name}.png") do
            {:ok, png} ->
              doc_name = Path.basename(png)
              Path.rootname(doc_name)

            _ ->
              nil
          end
        end

      {:noreply,
       socket
       |> assign(:page_title, page_title(socket.assigns.live_action))
       |> assign(:student, student)
       |> assign(:stam, "show student")
       |> assign(:stddocs, Students.list_stddocs(id, filter_by, search))
       |> assign(:document_name, png)
       |> assign(:stddoc, stddoc)}
    else
      {:noreply,
       socket
       |> assign(:page_title, page_title(socket.assigns.live_action))
       |> assign(:student, student)
       |> assign(:stam, "show student")
       |> assign(:stddocs, Students.list_stddocs(id, filter_by, search))
       |> assign(:document_name, "")
       |> assign(:stddoc, stddoc)}
    end
  end

  @impl true
  def handle_event("filter_by", %{"id" => id}, socket) do
    search = socket.assigns.search

    id =
      case id do
        "" -> nil
        id -> String.to_integer(id)
      end

    stddocs = Students.list_stddocs(socket.assigns.student.id, id, search)

    {:noreply, assign(socket, stddocs: stddocs, filter_by: id)}
  end

  @impl true
  def handle_event("search", %{"search" => search}, socket) do
    filter_by = socket.assigns.filter_by
    stddocs = Students.list_stddocs(socket.assigns.student.id, filter_by, search)

    {:noreply, assign(socket, stddocs: stddocs, search: search)}
  end

  defp pdf_thumbnail(pdf_path, thumb_path) do
    IO.inspect(thumb_path, label: "*** pdf: [#{pdf_path}]")

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

  defp page_title(:show), do: "Show Stddoc"
  defp page_title(:edit), do: "Edit Stddoc"
end
