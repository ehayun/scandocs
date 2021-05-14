defmodule ScandocWeb.StddocLive.Index do
  use ScandocWeb, :live_view

  alias Scandoc.Documents
  alias Scandoc.Students
  alias Scandoc.Students.Stddoc

  @impl true
  def mount(params, _session, socket) do
    docgroups = Documents.list_student_docgroups()

    student_id =
      case params do
        %{"student" => student_id} -> student_id
        _ -> nil
      end

    if student_id do
      student = Students.get_student!(student_id)

      {:ok,
       assign(socket,
         docgroups: docgroups,
         student: student,
         sort_by: nil,
         stddocs: fetch_stddocs(student_id)
       )}
    else
      {:ok, assign(socket, sort_by: nil, stddocs: [], docgroups: docgroups)}
    end
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    document = Students.get_stddoc!(id)


    path = document.doc_path
    path = String.replace(path, "/home/eli", "/downloads")

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

    socket
    |> assign(:page_title, png)
    |> assign(:doc_path, png)
    |> assign(:stddoc, document)
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Stddoc")
    |> assign(:stddoc, %Stddoc{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Stddocs")
    |> assign(:stddoc, nil)
  end

  @impl true

  def handle_event("sort_by", %{"id" => id}, socket) do
    id =
      case id do
        "" -> nil
        id -> String.to_integer(id)
      end

    stddocs = Students.list_stddocs(socket.assigns.student.id, id)

    {:noreply, assign(socket, stddocs: stddocs, sort_by: id)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    # stddoc = Students.get_stddoc!(id)
    # {:ok, _} = Students.delete_stddoc(stddoc)

    {:noreply, assign(socket, :stddocs, fetch_stddocs(id))}
  end

  defp fetch_stddocs(student_id) do
    Students.list_stddocs(student_id)
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
end
