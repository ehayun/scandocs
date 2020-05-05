defmodule ScandocWeb.DocumentControllerTest do
  use ScandocWeb.ConnCase

  alias Scandoc.Documents

  @create_attrs %{
    doc_name: "some doc_name",
    doc_name_len: 42,
    doc_path: "some doc_path",
    doctype_id: 42,
    has_picture: true,
    line_code: "some line_code",
    ref_id: 42,
    ref_month: "some ref_month",
    ref_year: "some ref_year"
  }
  @update_attrs %{
    doc_name: "some updated doc_name",
    doc_name_len: 43,
    doc_path: "some updated doc_path",
    doctype_id: 43,
    has_picture: false,
    line_code: "some updated line_code",
    ref_id: 43,
    ref_month: "some updated ref_month",
    ref_year: "some updated ref_year"
  }
  @invalid_attrs %{
    doc_name: nil,
    doc_name_len: nil,
    doc_path: nil,
    doctype_id: nil,
    has_picture: nil,
    line_code: nil,
    ref_id: nil,
    ref_month: nil,
    ref_year: nil
  }

  def fixture(:document) do
    {:ok, document} = Documents.create_document(@create_attrs)
    document
  end

  describe "index" do
    test "lists all documents", %{conn: conn} do
      conn = get(conn, Routes.document_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Documents"
    end
  end

  describe "new document" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.document_path(conn, :new))
      assert html_response(conn, 200) =~ "New Document"
    end
  end

  describe "create document" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.document_path(conn, :create), document: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.document_path(conn, :show, id)

      conn = get(conn, Routes.document_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Document"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.document_path(conn, :create), document: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Document"
    end
  end

  describe "edit document" do
    setup [:create_document]

    test "renders form for editing chosen document", %{conn: conn, document: document} do
      conn = get(conn, Routes.document_path(conn, :edit, document))
      assert html_response(conn, 200) =~ "Edit Document"
    end
  end

  describe "update document" do
    setup [:create_document]

    test "redirects when data is valid", %{conn: conn, document: document} do
      conn = put(conn, Routes.document_path(conn, :update, document), document: @update_attrs)
      assert redirected_to(conn) == Routes.document_path(conn, :show, document)

      conn = get(conn, Routes.document_path(conn, :show, document))
      assert html_response(conn, 200) =~ "some updated doc_name"
    end

    test "renders errors when data is invalid", %{conn: conn, document: document} do
      conn = put(conn, Routes.document_path(conn, :update, document), document: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Document"
    end
  end

  describe "delete document" do
    setup [:create_document]

    test "deletes chosen document", %{conn: conn, document: document} do
      conn = delete(conn, Routes.document_path(conn, :delete, document))
      assert redirected_to(conn) == Routes.document_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.document_path(conn, :show, document))
      end
    end
  end

  defp create_document(_) do
    document = fixture(:document)
    %{document: document}
  end
end
