defmodule Scandoc.DocumentsTest do
  use Scandoc.DataCase

  alias Scandoc.Documents

  describe "documents" do
    alias Scandoc.Documents.Document

    @valid_attrs %{
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

  describe "doctypes" do
    alias Scandoc.Documents.Doctype

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def doctype_fixture(attrs \\ %{}) do
      {:ok, doctype} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Documents.create_doctype()

      doctype
    end

    test "list_doctypes/0 returns all doctypes" do
      doctype = doctype_fixture()
      assert Documents.list_doctypes() == [doctype]
    end

    test "get_doctype!/1 returns the doctype with given id" do
      doctype = doctype_fixture()
      assert Documents.get_doctype!(doctype.id) == doctype
    end

    test "create_doctype/1 with valid data creates a doctype" do
      assert {:ok, %Doctype{} = doctype} = Documents.create_doctype(@valid_attrs)
    end

    test "create_doctype/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Documents.create_doctype(@invalid_attrs)
    end

    test "update_doctype/2 with valid data updates the doctype" do
      doctype = doctype_fixture()
      assert {:ok, %Doctype{} = doctype} = Documents.update_doctype(doctype, @update_attrs)
    end

    test "update_doctype/2 with invalid data returns error changeset" do
      doctype = doctype_fixture()
      assert {:error, %Ecto.Changeset{}} = Documents.update_doctype(doctype, @invalid_attrs)
      assert doctype == Documents.get_doctype!(doctype.id)
    end

    test "delete_doctype/1 deletes the doctype" do
      doctype = doctype_fixture()
      assert {:ok, %Doctype{}} = Documents.delete_doctype(doctype)
      assert_raise Ecto.NoResultsError, fn -> Documents.get_doctype!(doctype.id) end
    end

    test "change_doctype/1 returns a doctype changeset" do
      doctype = doctype_fixture()
      assert %Ecto.Changeset{} = Documents.change_doctype(doctype)
    end
  end

  describe "docgroups" do
    alias Scandoc.Documents.Docgroup

    @valid_attrs %{grp_id: 42, grp_name: "some grp_name"}
    @update_attrs %{grp_id: 43, grp_name: "some updated grp_name"}
    @invalid_attrs %{grp_id: nil, grp_name: nil}

    def docgroup_fixture(attrs \\ %{}) do
      {:ok, docgroup} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Documents.create_docgroup()

      docgroup
    end

    test "list_docgroups/0 returns all docgroups" do
      docgroup = docgroup_fixture()
      assert Documents.list_docgroups() == [docgroup]
    end

    test "get_docgroup!/1 returns the docgroup with given id" do
      docgroup = docgroup_fixture()
      assert Documents.get_docgroup!(docgroup.id) == docgroup
    end

    test "create_docgroup/1 with valid data creates a docgroup" do
      assert {:ok, %Docgroup{} = docgroup} = Documents.create_docgroup(@valid_attrs)
      assert docgroup.grp_id == 42
      assert docgroup.grp_name == "some grp_name"
    end

    test "create_docgroup/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Documents.create_docgroup(@invalid_attrs)
    end

    test "update_docgroup/2 with valid data updates the docgroup" do
      docgroup = docgroup_fixture()
      assert {:ok, %Docgroup{} = docgroup} = Documents.update_docgroup(docgroup, @update_attrs)
      assert docgroup.grp_id == 43
      assert docgroup.grp_name == "some updated grp_name"
    end

    test "update_docgroup/2 with invalid data returns error changeset" do
      docgroup = docgroup_fixture()
      assert {:error, %Ecto.Changeset{}} = Documents.update_docgroup(docgroup, @invalid_attrs)
      assert docgroup == Documents.get_docgroup!(docgroup.id)
    end

    test "delete_docgroup/1 deletes the docgroup" do
      docgroup = docgroup_fixture()
      assert {:ok, %Docgroup{}} = Documents.delete_docgroup(docgroup)
      assert_raise Ecto.NoResultsError, fn -> Documents.get_docgroup!(docgroup.id) end
    end

    test "change_docgroup/1 returns a docgroup changeset" do
      docgroup = docgroup_fixture()
      assert %Ecto.Changeset{} = Documents.change_docgroup(docgroup)
    end
  end
end
