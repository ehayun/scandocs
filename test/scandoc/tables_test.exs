defmodule Scandoc.TablesTest do
  use Scandoc.DataCase

  alias Scandoc.Tables

  describe "cities" do
    alias Scandoc.Tables.City

    @valid_attrs %{code: "some code", title: "some title"}
    @update_attrs %{code: "some updated code", title: "some updated title"}
    @invalid_attrs %{code: nil, title: nil}

    def city_fixture(attrs \\ %{}) do
      {:ok, city} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Tables.create_city()

      city
    end

    test "list_cities/0 returns all cities" do
      city = city_fixture()
      assert Tables.list_cities() == [city]
    end

    test "get_city!/1 returns the city with given id" do
      city = city_fixture()
      assert Tables.get_city!(city.id) == city
    end

    test "create_city/1 with valid data creates a city" do
      assert {:ok, %City{} = city} = Tables.create_city(@valid_attrs)
      assert city.code == "some code"
      assert city.title == "some title"
    end

    test "create_city/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tables.create_city(@invalid_attrs)
    end

    test "update_city/2 with valid data updates the city" do
      city = city_fixture()
      assert {:ok, %City{} = city} = Tables.update_city(city, @update_attrs)
      assert city.code == "some updated code"
      assert city.title == "some updated title"
    end

    test "update_city/2 with invalid data returns error changeset" do
      city = city_fixture()
      assert {:error, %Ecto.Changeset{}} = Tables.update_city(city, @invalid_attrs)
      assert city == Tables.get_city!(city.id)
    end

    test "delete_city/1 deletes the city" do
      city = city_fixture()
      assert {:ok, %City{}} = Tables.delete_city(city)
      assert_raise Ecto.NoResultsError, fn -> Tables.get_city!(city.id) end
    end

    test "change_city/1 returns a city changeset" do
      city = city_fixture()
      assert %Ecto.Changeset{} = Tables.change_city(city)
    end
  end
end
