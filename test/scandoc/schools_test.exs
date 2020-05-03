defmodule Scandoc.SchoolsTest do
  use Scandoc.DataCase

  alias Scandoc.Schools

  describe "schools" do
    alias Scandoc.Schools.School

    @valid_attrs %{code: "some code", manager_id: 42, school_name: "some school_name"}
    @update_attrs %{code: "some updated code", manager_id: 43, school_name: "some updated school_name"}
    @invalid_attrs %{code: nil, manager_id: nil, school_name: nil}

    def school_fixture(attrs \\ %{}) do
      {:ok, school} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Schools.create_school()

      school
    end

    test "list_schools/0 returns all schools" do
      school = school_fixture()
      assert Schools.list_schools() == [school]
    end

    test "get_school!/1 returns the school with given id" do
      school = school_fixture()
      assert Schools.get_school!(school.id) == school
    end

    test "create_school/1 with valid data creates a school" do
      assert {:ok, %School{} = school} = Schools.create_school(@valid_attrs)
      assert school.code == "some code"
      assert school.manager_id == 42
      assert school.school_name == "some school_name"
    end

    test "create_school/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Schools.create_school(@invalid_attrs)
    end

    test "update_school/2 with valid data updates the school" do
      school = school_fixture()
      assert {:ok, %School{} = school} = Schools.update_school(school, @update_attrs)
      assert school.code == "some updated code"
      assert school.manager_id == 43
      assert school.school_name == "some updated school_name"
    end

    test "update_school/2 with invalid data returns error changeset" do
      school = school_fixture()
      assert {:error, %Ecto.Changeset{}} = Schools.update_school(school, @invalid_attrs)
      assert school == Schools.get_school!(school.id)
    end

    test "delete_school/1 deletes the school" do
      school = school_fixture()
      assert {:ok, %School{}} = Schools.delete_school(school)
      assert_raise Ecto.NoResultsError, fn -> Schools.get_school!(school.id) end
    end

    test "change_school/1 returns a school changeset" do
      school = school_fixture()
      assert %Ecto.Changeset{} = Schools.change_school(school)
    end
  end

  describe "managers" do
    alias Scandoc.Schools.Manager

    @valid_attrs %{full_name: "some full_name", zehut: "some zehut"}
    @update_attrs %{full_name: "some updated full_name", zehut: "some updated zehut"}
    @invalid_attrs %{full_name: nil, zehut: nil}

    def manager_fixture(attrs \\ %{}) do
      {:ok, manager} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Schools.create_manager()

      manager
    end

    test "list_managers/0 returns all managers" do
      manager = manager_fixture()
      assert Schools.list_managers() == [manager]
    end

    test "get_manager!/1 returns the manager with given id" do
      manager = manager_fixture()
      assert Schools.get_manager!(manager.id) == manager
    end

    test "create_manager/1 with valid data creates a manager" do
      assert {:ok, %Manager{} = manager} = Schools.create_manager(@valid_attrs)
      assert manager.full_name == "some full_name"
      assert manager.zehut == "some zehut"
    end

    test "create_manager/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Schools.create_manager(@invalid_attrs)
    end

    test "update_manager/2 with valid data updates the manager" do
      manager = manager_fixture()
      assert {:ok, %Manager{} = manager} = Schools.update_manager(manager, @update_attrs)
      assert manager.full_name == "some updated full_name"
      assert manager.zehut == "some updated zehut"
    end

    test "update_manager/2 with invalid data returns error changeset" do
      manager = manager_fixture()
      assert {:error, %Ecto.Changeset{}} = Schools.update_manager(manager, @invalid_attrs)
      assert manager == Schools.get_manager!(manager.id)
    end

    test "delete_manager/1 deletes the manager" do
      manager = manager_fixture()
      assert {:ok, %Manager{}} = Schools.delete_manager(manager)
      assert_raise Ecto.NoResultsError, fn -> Schools.get_manager!(manager.id) end
    end

    test "change_manager/1 returns a manager changeset" do
      manager = manager_fixture()
      assert %Ecto.Changeset{} = Schools.change_manager(manager)
    end
  end
end
