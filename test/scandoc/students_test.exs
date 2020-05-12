defmodule Scandoc.StudentsTest do
  use Scandoc.DataCase

  alias Scandoc.Students

  describe "students" do
    alias Scandoc.Students.Student

    @valid_attrs %{
      classroom_id: 42,
      full_name: "some full_name",
      has_picture: true,
      student_zehut: "some student_zehut"
    }
    @update_attrs %{
      classroom_id: 43,
      full_name: "some updated full_name",
      has_picture: false,
      student_zehut: "some updated student_zehut"
    }
    @invalid_attrs %{classroom_id: nil, full_name: nil, has_picture: nil, student_zehut: nil}

    def student_fixture(attrs \\ %{}) do
      {:ok, student} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Students.create_student()

      student
    end

    test "list_students/0 returns all students" do
      student = student_fixture()
      assert Students.list_students() == [student]
    end

    test "get_student!/1 returns the student with given id" do
      student = student_fixture()
      assert Students.get_student!(student.id) == student
    end

    test "create_student/1 with valid data creates a student" do
      assert {:ok, %Student{} = student} = Students.create_student(@valid_attrs)
      assert student.classroom_id == 42
      assert student.full_name == "some full_name"
      assert student.has_picture == true
      assert student.student_zehut == "some student_zehut"
    end

    test "create_student/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Students.create_student(@invalid_attrs)
    end

    test "update_student/2 with valid data updates the student" do
      student = student_fixture()
      assert {:ok, %Student{} = student} = Students.update_student(student, @update_attrs)
      assert student.classroom_id == 43
      assert student.full_name == "some updated full_name"
      assert student.has_picture == false
      assert student.student_zehut == "some updated student_zehut"
    end

    test "update_student/2 with invalid data returns error changeset" do
      student = student_fixture()
      assert {:error, %Ecto.Changeset{}} = Students.update_student(student, @invalid_attrs)
      assert student == Students.get_student!(student.id)
    end

    test "delete_student/1 deletes the student" do
      student = student_fixture()
      assert {:ok, %Student{}} = Students.delete_student(student)
      assert_raise Ecto.NoResultsError, fn -> Students.get_student!(student.id) end
    end

    test "change_student/1 returns a student changeset" do
      student = student_fixture()
      assert %Ecto.Changeset{} = Students.change_student(student)
    end
  end

  describe "stddocs" do
    alias Scandoc.Students.Stddoc

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def stddoc_fixture(attrs \\ %{}) do
      {:ok, stddoc} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Students.create_stddoc()

      stddoc
    end

    test "list_stddocs/0 returns all stddocs" do
      stddoc = stddoc_fixture()
      assert Students.list_stddocs() == [stddoc]
    end

    test "get_stddoc!/1 returns the stddoc with given id" do
      stddoc = stddoc_fixture()
      assert Students.get_stddoc!(stddoc.id) == stddoc
    end

    test "create_stddoc/1 with valid data creates a stddoc" do
      assert {:ok, %Stddoc{} = stddoc} = Students.create_stddoc(@valid_attrs)
    end

    test "create_stddoc/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Students.create_stddoc(@invalid_attrs)
    end

    test "update_stddoc/2 with valid data updates the stddoc" do
      stddoc = stddoc_fixture()
      assert {:ok, %Stddoc{} = stddoc} = Students.update_stddoc(stddoc, @update_attrs)
    end

    test "update_stddoc/2 with invalid data returns error changeset" do
      stddoc = stddoc_fixture()
      assert {:error, %Ecto.Changeset{}} = Students.update_stddoc(stddoc, @invalid_attrs)
      assert stddoc == Students.get_stddoc!(stddoc.id)
    end

    test "delete_stddoc/1 deletes the stddoc" do
      stddoc = stddoc_fixture()
      assert {:ok, %Stddoc{}} = Students.delete_stddoc(stddoc)
      assert_raise Ecto.NoResultsError, fn -> Students.get_stddoc!(stddoc.id) end
    end

    test "change_stddoc/1 returns a stddoc changeset" do
      stddoc = stddoc_fixture()
      assert %Ecto.Changeset{} = Students.change_stddoc(stddoc)
    end
  end
end
