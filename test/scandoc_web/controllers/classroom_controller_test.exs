defmodule ScandocWeb.ClassroomControllerTest do
  use ScandocWeb.ConnCase

  alias Scandoc.Classrooms

  @create_attrs %{
    classroom_name: "some classroom_name",
    code: "some code",
    school_id: 42,
    teacher_id: 42
  }
  @update_attrs %{
    classroom_name: "some updated classroom_name",
    code: "some updated code",
    school_id: 43,
    teacher_id: 43
  }
  @invalid_attrs %{classroom_name: nil, code: nil, school_id: nil, teacher_id: nil}

  def fixture(:classroom) do
    {:ok, classroom} = Classrooms.create_classroom(@create_attrs)
    classroom
  end

  describe "index" do
    test "lists all classrooms", %{conn: conn} do
      conn = get(conn, Routes.classroom_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Classrooms"
    end
  end

  describe "new classroom" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.classroom_path(conn, :new))
      assert html_response(conn, 200) =~ "New Classroom"
    end
  end

  describe "create classroom" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.classroom_path(conn, :create), classroom: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.classroom_path(conn, :show, id)

      conn = get(conn, Routes.classroom_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Classroom"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.classroom_path(conn, :create), classroom: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Classroom"
    end
  end

  describe "edit classroom" do
    setup [:create_classroom]

    test "renders form for editing chosen classroom", %{conn: conn, classroom: classroom} do
      conn = get(conn, Routes.classroom_path(conn, :edit, classroom))
      assert html_response(conn, 200) =~ "Edit Classroom"
    end
  end

  describe "update classroom" do
    setup [:create_classroom]

    test "redirects when data is valid", %{conn: conn, classroom: classroom} do
      conn = put(conn, Routes.classroom_path(conn, :update, classroom), classroom: @update_attrs)
      assert redirected_to(conn) == Routes.classroom_path(conn, :show, classroom)

      conn = get(conn, Routes.classroom_path(conn, :show, classroom))
      assert html_response(conn, 200) =~ "some updated classroom_name"
    end

    test "renders errors when data is invalid", %{conn: conn, classroom: classroom} do
      conn = put(conn, Routes.classroom_path(conn, :update, classroom), classroom: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Classroom"
    end
  end

  describe "delete classroom" do
    setup [:create_classroom]

    test "deletes chosen classroom", %{conn: conn, classroom: classroom} do
      conn = delete(conn, Routes.classroom_path(conn, :delete, classroom))
      assert redirected_to(conn) == Routes.classroom_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.classroom_path(conn, :show, classroom))
      end
    end
  end

  defp create_classroom(_) do
    classroom = fixture(:classroom)
    %{classroom: classroom}
  end
end
