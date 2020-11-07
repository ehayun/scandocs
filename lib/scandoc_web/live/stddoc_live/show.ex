defmodule ScandocWeb.StddocLive.Show do
  use ScandocWeb, :live_view

  alias Scandoc.Students

  alias Scandoc.{Documents, Students}
  alias Scandoc.Student.Show.{Contacts, Comments, Details}
  alias Scandoc.Students.Stddoc


  @impl true
  def mount(_params, _session, socket) do
    docgroups = Documents.list_student_docgroups()

    {
      :ok,
      assign(
        socket,
        edit_doc_id: 0,
        editId: 0,
        docgroups: docgroups,
        tabnum: 2,
        filter_by: nil,
        search: "",
        add_link: false,
        edit_link: false
      )
    }
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

    {
      :noreply,
      socket
      |> assign(:page_title, page_title(socket.assigns.live_action))
      |> assign(:student, student)
      |> assign(:stddocs, Students.list_stddocs(id, filter_by, search))
      |> assign(:document_name, "")
      |> assign(:stddoc, stddoc)
    }
  end

  @impl true
  def handle_event("setEditRemark", %{"id" => docid}, socket) do
    changeset = Students.get_stddoc!(docid)
                |> Students.change_stddoc()
    {:noreply, assign(socket, changeset: changeset, editId: String.to_integer(docid))}
  end

  def handle_event("close-remark", _, socket) do
    {:noreply, assign(socket, editId: 0)}
  end

  @impl true
  def handle_event("add_link", _params, socket) do
    changeset = Students.change_stddoc(%Stddoc{})
    {:noreply, assign(socket, add_link: true, changeset: changeset)}
  end

  @impl true
  def handle_event("close-link", _params, socket) do
    {:noreply, assign(socket, add_link: false)}
  end

  @impl true
  def handle_event("edit-link", %{"id" => id}, socket) do
    sdoc = Students.get_stddoc!(id)
    changeset = Students.change_stddoc(sdoc)
    {:noreply, assign(socket, edit_link: true, edit_doc_id: String.to_integer(id), changeset: changeset)}
  end

  @impl true
  def handle_event("save-link", %{"stddoc" => stddoc}, socket) do
    student = socket.assigns.student
    %{"doc_name" => doc_name, "doc_path" => doc_path, "id" => id} = stddoc
    result = if id > "" do
      doc = Students.get_stddoc!(id)
      Students.update_stddoc(doc, stddoc)
    else
      doctype_id = 775
      Students.create_stddoc(
        %{ref_id: student.id, doc_name: doc_name, doc_path: doc_path, doctype_id: doctype_id}
      )
    end

    socket = case result do
      {:ok, _} ->
        assign(
          socket,
          add_link: false,
          edit_doc_id: false,
          stddocs:
            Students.list_stddocs(student.id, socket.assigns.filter_by, socket.assigns.search)
        )
      {:error, cs} -> assign(socket, changeset: cs)
    end
    {:noreply, socket}
  end

  @impl true
  def handle_event("delete-link", %{"id" => id}, socket) do
    student = socket.assigns.student

    doc = Students.get_stddoc!(id)
    Students.delete_stddoc(doc)
    socket = assign(
      socket,
      add_link: false,
      edit_doc_id: false,
      stddocs:
        Students.list_stddocs(student.id, socket.assigns.filter_by, socket.assigns.search)
    )
    {:noreply, socket}
  end

  def handle_event("save-remark", %{"stddoc" => stddoc}, socket) do
    socket =
      case stddoc do
        %{"id" => id, "remarks" => remarks, "done" => done} ->
          sdoc = Students.get_stddoc!(id)
          attrs = %{remarks: remarks, done: done}
          Students.update_stddoc(sdoc, attrs)

          assign(
            socket,
            :stddocs,
            Students.list_stddocs(sdoc.ref_id, socket.assigns.filter_by, socket.assigns.search)
          )

        _ ->
          socket
      end

    {:noreply, assign(socket, editId: 0)}
  end

  def handle_event("save-remark", _params, socket) do
    {:noreply, assign(socket, editId: 0)}
  end

  @impl true
  def handle_event("setTab", %{"tabid" => tabnum}, socket) do
    {:noreply, assign(socket, tabnum: String.to_integer(tabnum))}
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

  defp page_title(:show), do: "Show Stddoc"
  defp page_title(:edit), do: "Edit Stddoc"
end
