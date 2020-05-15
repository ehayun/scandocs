defmodule Scandoc.CategoriesTest do
  use Scandoc.DataCase

  alias Scandoc.Categories

  describe "categories" do
    alias Scandoc.Categories.Category

    @valid_attrs %{category_name: "some category_name", code: "some code"}
    @update_attrs %{category_name: "some updated category_name", code: "some updated code"}
    @invalid_attrs %{category_name: nil, code: nil}

    def category_fixture(attrs \\ %{}) do
      {:ok, category} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Categories.create_category()

      category
    end

    test "list_categories/0 returns all categories" do
      category = category_fixture()
      assert Categories.list_categories() == [category]
    end

    test "get_category!/1 returns the category with given id" do
      category = category_fixture()
      assert Categories.get_category!(category.id) == category
    end

    test "create_category/1 with valid data creates a category" do
      assert {:ok, %Category{} = category} = Categories.create_category(@valid_attrs)
      assert category.category_name == "some category_name"
      assert category.code == "some code"
    end

    test "create_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Categories.create_category(@invalid_attrs)
    end

    test "update_category/2 with valid data updates the category" do
      category = category_fixture()
      assert {:ok, %Category{} = category} = Categories.update_category(category, @update_attrs)
      assert category.category_name == "some updated category_name"
      assert category.code == "some updated code"
    end

    test "update_category/2 with invalid data returns error changeset" do
      category = category_fixture()
      assert {:error, %Ecto.Changeset{}} = Categories.update_category(category, @invalid_attrs)
      assert category == Categories.get_category!(category.id)
    end

    test "delete_category/1 deletes the category" do
      category = category_fixture()
      assert {:ok, %Category{}} = Categories.delete_category(category)
      assert_raise Ecto.NoResultsError, fn -> Categories.get_category!(category.id) end
    end

    test "change_category/1 returns a category changeset" do
      category = category_fixture()
      assert %Ecto.Changeset{} = Categories.change_category(category)
    end
  end

  describe "outcome_categoryes" do
    alias Scandoc.Categories.OutcomeCategory

    @valid_attrs %{category_id: 42, outcome_card: "some outcome_card", outcome_description: "some outcome_description"}
    @update_attrs %{category_id: 43, outcome_card: "some updated outcome_card", outcome_description: "some updated outcome_description"}
    @invalid_attrs %{category_id: nil, outcome_card: nil, outcome_description: nil}

    def outcome_category_fixture(attrs \\ %{}) do
      {:ok, outcome_category} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Categories.create_outcome_category()

      outcome_category
    end

    test "list_outcome_categoryes/0 returns all outcome_categoryes" do
      outcome_category = outcome_category_fixture()
      assert Categories.list_outcome_categoryes() == [outcome_category]
    end

    test "get_outcome_category!/1 returns the outcome_category with given id" do
      outcome_category = outcome_category_fixture()
      assert Categories.get_outcome_category!(outcome_category.id) == outcome_category
    end

    test "create_outcome_category/1 with valid data creates a outcome_category" do
      assert {:ok, %OutcomeCategory{} = outcome_category} = Categories.create_outcome_category(@valid_attrs)
      assert outcome_category.category_id == 42
      assert outcome_category.outcome_card == "some outcome_card"
      assert outcome_category.outcome_description == "some outcome_description"
    end

    test "create_outcome_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Categories.create_outcome_category(@invalid_attrs)
    end

    test "update_outcome_category/2 with valid data updates the outcome_category" do
      outcome_category = outcome_category_fixture()
      assert {:ok, %OutcomeCategory{} = outcome_category} = Categories.update_outcome_category(outcome_category, @update_attrs)
      assert outcome_category.category_id == 43
      assert outcome_category.outcome_card == "some updated outcome_card"
      assert outcome_category.outcome_description == "some updated outcome_description"
    end

    test "update_outcome_category/2 with invalid data returns error changeset" do
      outcome_category = outcome_category_fixture()
      assert {:error, %Ecto.Changeset{}} = Categories.update_outcome_category(outcome_category, @invalid_attrs)
      assert outcome_category == Categories.get_outcome_category!(outcome_category.id)
    end

    test "delete_outcome_category/1 deletes the outcome_category" do
      outcome_category = outcome_category_fixture()
      assert {:ok, %OutcomeCategory{}} = Categories.delete_outcome_category(outcome_category)
      assert_raise Ecto.NoResultsError, fn -> Categories.get_outcome_category!(outcome_category.id) end
    end

    test "change_outcome_category/1 returns a outcome_category changeset" do
      outcome_category = outcome_category_fixture()
      assert %Ecto.Changeset{} = Categories.change_outcome_category(outcome_category)
    end
  end
end
