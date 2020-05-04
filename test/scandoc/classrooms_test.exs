defmodule Scandoc.ClassroomsTest do
  use Scandoc.DataCase

  alias Scandoc.Classrooms

  describe "classrooms" do
    alias Scandoc.Classrooms.Classroom

    @valid_attrs %{classroom_name: "some classroom_name", code: "some code", school_id: 42, teacher_id: 42}
    @update_attrs %{classroom_name: "some updated classroom_name", code: "some updated code", school_id: 43, teacher_id: 43}
    @invalid_attrs %{classroom_name: nil, code: nil, school_id: nil, teacher_id: nil}

    def classroom_fixture(attrs \\ %{}) do
      {:ok, classroom} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Classrooms.create_classroom()

      classroom
    end

    test "list_classrooms/0 returns all classrooms" do
      classroom = classroom_fixture()
      assert Classrooms.list_classrooms() == [classroom]
    end

    test "get_classroom!/1 returns the classroom with given id" do
      classroom = classroom_fixture()
      assert Classrooms.get_classroom!(classroom.id) == classroom
    end

    test "create_classroom/1 with valid data creates a classroom" do
      assert {:ok, %Classroom{} = classroom} = Classrooms.create_classroom(@valid_attrs)
      assert classroom.classroom_name == "some classroom_name"
      assert classroom.code == "some code"
      assert classroom.school_id == 42
      assert classroom.teacher_id == 42
    end

    test "create_classroom/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Classrooms.create_classroom(@invalid_attrs)
    end

    test "update_classroom/2 with valid data updates the classroom" do
      classroom = classroom_fixture()
      assert {:ok, %Classroom{} = classroom} = Classrooms.update_classroom(classroom, @update_attrs)
      assert classroom.classroom_name == "some updated classroom_name"
      assert classroom.code == "some updated code"
      assert classroom.school_id == 43
      assert classroom.teacher_id == 43
    end

    test "update_classroom/2 with invalid data returns error changeset" do
      classroom = classroom_fixture()
      assert {:error, %Ecto.Changeset{}} = Classrooms.update_classroom(classroom, @invalid_attrs)
      assert classroom == Classrooms.get_classroom!(classroom.id)
    end

    test "delete_classroom/1 deletes the classroom" do
      classroom = classroom_fixture()
      assert {:ok, %Classroom{}} = Classrooms.delete_classroom(classroom)
      assert_raise Ecto.NoResultsError, fn -> Classrooms.get_classroom!(classroom.id) end
    end

    test "change_classroom/1 returns a classroom changeset" do
      classroom = classroom_fixture()
      assert %Ecto.Changeset{} = Classrooms.change_classroom(classroom)
    end
  end
end
