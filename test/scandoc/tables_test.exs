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

  describe "districts" do
    alias Scandoc.Tables.District

    @valid_attrs %{district_name: "some district_name"}
    @update_attrs %{district_name: "some updated district_name"}
    @invalid_attrs %{district_name: nil}

    def district_fixture(attrs \\ %{}) do
      {:ok, district} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Tables.create_district()

      district
    end

    test "list_districts/0 returns all districts" do
      district = district_fixture()
      assert Tables.list_districts() == [district]
    end

    test "get_district!/1 returns the district with given id" do
      district = district_fixture()
      assert Tables.get_district!(district.id) == district
    end

    test "create_district/1 with valid data creates a district" do
      assert {:ok, %District{} = district} = Tables.create_district(@valid_attrs)
      assert district.district_name == "some district_name"
    end

    test "create_district/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tables.create_district(@invalid_attrs)
    end

    test "update_district/2 with valid data updates the district" do
      district = district_fixture()
      assert {:ok, %District{} = district} = Tables.update_district(district, @update_attrs)
      assert district.district_name == "some updated district_name"
    end

    test "update_district/2 with invalid data returns error changeset" do
      district = district_fixture()
      assert {:error, %Ecto.Changeset{}} = Tables.update_district(district, @invalid_attrs)
      assert district == Tables.get_district!(district.id)
    end

    test "delete_district/1 deletes the district" do
      district = district_fixture()
      assert {:ok, %District{}} = Tables.delete_district(district)
      assert_raise Ecto.NoResultsError, fn -> Tables.get_district!(district.id) end
    end

    test "change_district/1 returns a district changeset" do
      district = district_fixture()
      assert %Ecto.Changeset{} = Tables.change_district(district)
    end
  end
end
