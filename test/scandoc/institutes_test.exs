defmodule Scandoc.InstitutesTest do
  use Scandoc.DataCase

  alias Scandoc.Institutes

  describe "institutes" do
    alias Scandoc.Institutes.Institute

    @valid_attrs %{code: "some code", title: "some title"}
    @update_attrs %{code: "some updated code", title: "some updated title"}
    @invalid_attrs %{code: nil, title: nil}

    def institute_fixture(attrs \\ %{}) do
      {:ok, institute} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Institutes.create_institute()

      institute
    end

    test "list_institutes/0 returns all institutes" do
      institute = institute_fixture()
      assert Institutes.list_institutes() == [institute]
    end

    test "get_institute!/1 returns the institute with given id" do
      institute = institute_fixture()
      assert Institutes.get_institute!(institute.id) == institute
    end

    test "create_institute/1 with valid data creates a institute" do
      assert {:ok, %Institute{} = institute} = Institutes.create_institute(@valid_attrs)
      assert institute.code == "some code"
      assert institute.title == "some title"
    end

    test "create_institute/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Institutes.create_institute(@invalid_attrs)
    end

    test "update_institute/2 with valid data updates the institute" do
      institute = institute_fixture()

      assert {:ok, %Institute{} = institute} =
               Institutes.update_institute(institute, @update_attrs)

      assert institute.code == "some updated code"
      assert institute.title == "some updated title"
    end

    test "update_institute/2 with invalid data returns error changeset" do
      institute = institute_fixture()
      assert {:error, %Ecto.Changeset{}} = Institutes.update_institute(institute, @invalid_attrs)
      assert institute == Institutes.get_institute!(institute.id)
    end

    test "delete_institute/1 deletes the institute" do
      institute = institute_fixture()
      assert {:ok, %Institute{}} = Institutes.delete_institute(institute)
      assert_raise Ecto.NoResultsError, fn -> Institutes.get_institute!(institute.id) end
    end

    test "change_institute/1 returns a institute changeset" do
      institute = institute_fixture()
      assert %Ecto.Changeset{} = Institutes.change_institute(institute)
    end
  end

  describe "inst_docs" do
    alias Scandoc.Institutes.Instdoc

    @valid_attrs %{
      amount: "120.5",
      category_id: 42,
      code: "some code",
      doc_date: ~D[2010-04-17],
      doc_name: "some doc_name",
      doc_path: "some doc_path",
      line_code: "some line_code",
      outcome_category_id: 42,
      payment_code: "some payment_code",
      vendor_id: 42
    }
    @update_attrs %{
      amount: "456.7",
      category_id: 43,
      code: "some updated code",
      doc_date: ~D[2011-05-18],
      doc_name: "some updated doc_name",
      doc_path: "some updated doc_path",
      line_code: "some updated line_code",
      outcome_category_id: 43,
      payment_code: "some updated payment_code",
      vendor_id: 43
    }
    @invalid_attrs %{
      amount: nil,
      category_id: nil,
      code: nil,
      doc_date: nil,
      doc_name: nil,
      doc_path: nil,
      line_code: nil,
      outcome_category_id: nil,
      payment_code: nil,
      vendor_id: nil
    }

    def instdoc_fixture(attrs \\ %{}) do
      {:ok, instdoc} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Institutes.create_instdoc()

      instdoc
    end

    test "list_inst_docs/0 returns all inst_docs" do
      instdoc = instdoc_fixture()
      assert Institutes.list_inst_docs() == [instdoc]
    end

    test "get_instdoc!/1 returns the instdoc with given id" do
      instdoc = instdoc_fixture()
      assert Institutes.get_instdoc!(instdoc.id) == instdoc
    end

    test "create_instdoc/1 with valid data creates a instdoc" do
      assert {:ok, %Instdoc{} = instdoc} = Institutes.create_instdoc(@valid_attrs)
      assert instdoc.amount == Decimal.new("120.5")
      assert instdoc.category_id == 42
      assert instdoc.code == "some code"
      assert instdoc.doc_date == ~D[2010-04-17]
      assert instdoc.doc_name == "some doc_name"
      assert instdoc.doc_path == "some doc_path"
      assert instdoc.line_code == "some line_code"
      assert instdoc.outcome_category_id == 42
      assert instdoc.payment_code == "some payment_code"
      assert instdoc.vendor_id == 42
    end

    test "create_instdoc/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Institutes.create_instdoc(@invalid_attrs)
    end

    test "update_instdoc/2 with valid data updates the instdoc" do
      instdoc = instdoc_fixture()
      assert {:ok, %Instdoc{} = instdoc} = Institutes.update_instdoc(instdoc, @update_attrs)
      assert instdoc.amount == Decimal.new("456.7")
      assert instdoc.category_id == 43
      assert instdoc.code == "some updated code"
      assert instdoc.doc_date == ~D[2011-05-18]
      assert instdoc.doc_name == "some updated doc_name"
      assert instdoc.doc_path == "some updated doc_path"
      assert instdoc.line_code == "some updated line_code"
      assert instdoc.outcome_category_id == 43
      assert instdoc.payment_code == "some updated payment_code"
      assert instdoc.vendor_id == 43
    end

    test "update_instdoc/2 with invalid data returns error changeset" do
      instdoc = instdoc_fixture()
      assert {:error, %Ecto.Changeset{}} = Institutes.update_instdoc(instdoc, @invalid_attrs)
      assert instdoc == Institutes.get_instdoc!(instdoc.id)
    end

    test "delete_instdoc/1 deletes the instdoc" do
      instdoc = instdoc_fixture()
      assert {:ok, %Instdoc{}} = Institutes.delete_instdoc(instdoc)
      assert_raise Ecto.NoResultsError, fn -> Institutes.get_instdoc!(instdoc.id) end
    end

    test "change_instdoc/1 returns a instdoc changeset" do
      instdoc = instdoc_fixture()
      assert %Ecto.Changeset{} = Institutes.change_instdoc(instdoc)
    end
  end
end
