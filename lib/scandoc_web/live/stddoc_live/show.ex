defmodule ScandocWeb.StddocLive.Show do
  use ScandocWeb, :live_view

  alias Scandoc.Students

  # alias Scandoc.Documents
  # alias Scandoc.Students.Stddoc

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _session, socket) do
    # def handle_params(%{"id" => id}, _, socket) do

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
          _ -> Students.get_stddoc!(id)
        end
      end

    path = stddoc.doc_path
    path = String.replace(path, "/home/eli", "/downloads")

    png =
      if File.exists?(".#{path}") do
        doc_name = Path.basename(path)

        just_name = Path.rootname(doc_name)

        case pdf_thumbnail(".#{path}", "./priv/static//uploads/#{just_name}.png") do
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
     |> assign(:stddocs, Students.list_stddocs(id))
     |> assign(:document_name, png)
     |> assign(:return_to, "/stddocs/#{student.id}")
     |> assign(:stddoc, stddoc)}
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

  defp page_title(:show), do: "Show Stddoc"
  defp page_title(:edit), do: "Edit Stddoc"
end
