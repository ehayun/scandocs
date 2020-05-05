defmodule ScandocWeb.TeacherControllerTest do
  use ScandocWeb.ConnCase

  alias Scandoc.Schools

  @create_attrs %{
    date_of_birth: ~D[2010-04-17],
    full_name: "some full_name",
    hashed_password: "some hashed_password",
    role: "some role",
    zehut: "some zehut"
  }
  @update_attrs %{
    date_of_birth: ~D[2011-05-18],
    full_name: "some updated full_name",
    hashed_password: "some updated hashed_password",
    role: "some updated role",
    zehut: "some updated zehut"
  }
  @invalid_attrs %{
    date_of_birth: nil,
    full_name: nil,
    hashed_password: nil,
    role: nil,
    zehut: nil
  }

  def fixture(:teacher) do
    {:ok, teacher} = Schools.create_teacher(@create_attrs)
    teacher
  end

  describe "index" do
    test "lists all teachers", %{conn: conn} do
      conn = get(conn, Routes.teacher_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Teachers"
    end
  end

  describe "new teacher" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.teacher_path(conn, :new))
      assert html_response(conn, 200) =~ "New Teacher"
    end
  end

  describe "create teacher" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.teacher_path(conn, :create), teacher: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.teacher_path(conn, :show, id)

      conn = get(conn, Routes.teacher_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Teacher"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.teacher_path(conn, :create), teacher: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Teacher"
    end
  end

  describe "edit teacher" do
    setup [:create_teacher]

    test "renders form for editing chosen teacher", %{conn: conn, teacher: teacher} do
      conn = get(conn, Routes.teacher_path(conn, :edit, teacher))
      assert html_response(conn, 200) =~ "Edit Teacher"
    end
  end

  describe "update teacher" do
    setup [:create_teacher]

    test "redirects when data is valid", %{conn: conn, teacher: teacher} do
      conn = put(conn, Routes.teacher_path(conn, :update, teacher), teacher: @update_attrs)
      assert redirected_to(conn) == Routes.teacher_path(conn, :show, teacher)

      conn = get(conn, Routes.teacher_path(conn, :show, teacher))
      assert html_response(conn, 200) =~ "some updated full_name"
    end

    test "renders errors when data is invalid", %{conn: conn, teacher: teacher} do
      conn = put(conn, Routes.teacher_path(conn, :update, teacher), teacher: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Teacher"
    end
  end

  describe "delete teacher" do
    setup [:create_teacher]

    test "deletes chosen teacher", %{conn: conn, teacher: teacher} do
      conn = delete(conn, Routes.teacher_path(conn, :delete, teacher))
      assert redirected_to(conn) == Routes.teacher_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.teacher_path(conn, :show, teacher))
      end
    end
  end

  defp create_teacher(_) do
    teacher = fixture(:teacher)
    %{teacher: teacher}
  end
end
