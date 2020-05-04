defmodule Scandoc.DocumentsTest do
  use Scandoc.DataCase

  alias Scandoc.Documents

  describe "documents" do
    alias Scandoc.Documents.Document

    @valid_attrs %{doc_name: "some doc_name", doc_name_len: 42, doc_path: "some doc_path", doctype_id: 42, has_picture: true, line_code: "some line_code", ref_id: 42, ref_month: "some ref_month", ref_year: "some ref_year"}
    @update_attrs %{doc_name: "some updated doc_name", doc_name_len: 43, doc_path: "some updated doc_path", doctype_id: 43, has_picture: false, line_code: "some updated line_code", ref_id: 43, ref_month: "some updated ref_month", ref_year: "some updated ref_year"}
    @invalid_attrs %{doc_name: nil, doc_name_len: nil, doc_path: nil, doctype_id: nil, has_picture: nil, line_code: nil, ref_id: nil, ref_month: nil, ref_year: nil}

    def document_fixture(attrs \\ %{}) do
      {:ok, document} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Documents.create_document()

      document
    end

    test "list_documents/0 returns all documents" do
      document = document_fixture()
      assert Documents.list_documents() == [document]
    end

    test "get_document!/1 returns the document with given id" do
      document = document_fixture()
      assert Documents.get_document!(document.id) == document
    end

    test "create_document/1 with valid data creates a document" do
      assert {:ok, %Document{} = document} = Documents.create_document(@valid_attrs)
      assert document.doc_name == "some doc_name"
      assert document.doc_name_len == 42
      assert document.doc_path == "some doc_path"
      assert document.doctype_id == 42
      assert document.has_picture == true
      assert document.line_code == "some line_code"
      assert document.ref_id == 42
      assert document.ref_month == "some ref_month"
      assert document.ref_year == "some ref_year"
    end

    test "create_document/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Documents.create_document(@invalid_attrs)
    end

    test "update_document/2 with valid data updates the document" do
      document = document_fixture()
      assert {:ok, %Document{} = document} = Documents.update_document(document, @update_attrs)
      assert document.doc_name == "some updated doc_name"
      assert document.doc_name_len == 43
      assert document.doc_path == "some updated doc_path"
      assert document.doctype_id == 43
      assert document.has_picture == false
      assert document.line_code == "some updated line_code"
      assert document.ref_id == 43
      assert document.ref_month == "some updated ref_month"
      assert document.ref_year == "some updated ref_year"
    end

    test "update_document/2 with invalid data returns error changeset" do
      document = document_fixture()
      assert {:error, %Ecto.Changeset{}} = Documents.update_document(document, @invalid_attrs)
      assert document == Documents.get_document!(document.id)
    end

    test "delete_document/1 deletes the document" do
      document = document_fixture()
      assert {:ok, %Document{}} = Documents.delete_document(document)
      assert_raise Ecto.NoResultsError, fn -> Documents.get_document!(document.id) end
    end

    test "change_document/1 returns a document changeset" do
      document = document_fixture()
      assert %Ecto.Changeset{} = Documents.change_document(document)
    end
  end
end
