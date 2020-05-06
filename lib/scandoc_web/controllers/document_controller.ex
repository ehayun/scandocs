defmodule ScandocWeb.DocumentController do
  use ScandocWeb, :controller

  alias Scandoc.Documents
  alias Scandoc.Documents.Document
  alias Scandoc.Students

  def index(conn, _params) do
    documents = Documents.list_documents()
    render(conn, "index.html", documents: documents)
  end

  def new(conn, _params) do
    changeset = Documents.change_document(%Document{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"document" => document_params}) do
    case Documents.create_document(document_params) do
      {:ok, document} ->
        conn
        |> put_flash(:info, "Document created successfully.")
        |> redirect(to: Routes.document_path(conn, :show, document))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    document = Documents.get_document!(id)
    render(conn, "show.html", document: document)
  end

  def edit(conn, %{"id" => id}) do
    document = Documents.get_document!(id)
    changeset = Documents.change_document(document)
    render(conn, "edit.html", document: document, changeset: changeset)
  end

  def update(conn, %{"id" => id, "document" => document_params}) do
    document = Documents.get_document!(id)

    case Documents.update_document(document, document_params) do
      {:ok, document} ->
        conn
        |> put_flash(:info, "Document updated successfully.")
        |> redirect(to: Routes.document_path(conn, :show, document))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", document: document, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    document = Documents.get_document!(id)
    {:ok, _document} = Documents.delete_document(document)

    conn
    |> put_flash(:info, "Document deleted successfully.")
    |> redirect(to: Routes.document_path(conn, :index))
  end

  def doc_download(conn, %{"id" => id}) do
    # id = Integer.parse(id)
    document = Documents.get_document!(id)

    student =
      if document do
        Students.get_student!(document.ref_id)
      else
        nil
      end

    if document do
      path = document.doc_path
      path = String.replace(path, "/home/eli", "/downloads")

      # file = "#{path}/#{document.doc_name}"

      # IO.inspect(file, label: "#{document.doc_name}")

      # file = "/home/eli/pCloudDrive/Scan_files/חכמת_ישראל/גנים_חכמת_ישראל/אוחיון_יצחק_342232436/342232436-213-1119.pdf"
      # file = String.replace(file, "/home/eli", "./downloads")

      if File.exists?(".#{path}") do
        conn
        |> send_download({:file, ".#{path}"})

        # render(conn, "show.html", document: path)
      end
    else
      if !student do
        conn
        |> put_flash(:info, "File Not found")
        |> redirect(to: Routes.student_path(conn, :index))
      else
        conn
        |> put_flash(:info, "File Not found")
        |> redirect(to: Routes.student_path(conn, :show, student))
      end
    end
  end
end
