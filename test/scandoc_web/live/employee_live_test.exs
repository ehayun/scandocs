defmodule ScandocWeb.EmployeeLiveTest do
  use ScandocWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Scandoc.Employees

  @create_attrs %{
    date_of_birth: ~D[2010-04-17],
    full_name: "some full_name",
    hashed_password: "some hashed_password",
    is_admin: true,
    is_freezed: true,
    role: "some role",
    zehut: "some zehut"
  }
  @update_attrs %{
    date_of_birth: ~D[2011-05-18],
    full_name: "some updated full_name",
    hashed_password: "some updated hashed_password",
    is_admin: false,
    is_freezed: false,
    role: "some updated role",
    zehut: "some updated zehut"
  }
  @invalid_attrs %{
    date_of_birth: nil,
    full_name: nil,
    hashed_password: nil,
    is_admin: nil,
    is_freezed: nil,
    role: nil,
    zehut: nil
  }

  defp fixture(:employee) do
    {:ok, employee} = Employees.create_employee(@create_attrs)
    employee
  end

  defp create_employee(_) do
    employee = fixture(:employee)
    %{employee: employee}
  end

  describe "Index" do
    setup [:create_employee]

    test "lists all employees", %{conn: conn, employee: employee} do
      {:ok, _index_live, html} = live(conn, Routes.employee_index_path(conn, :index))

      assert html =~ "Listing Employees"
      assert html =~ employee.full_name
    end

    test "saves new employee", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.employee_index_path(conn, :index))

      assert index_live |> element("a", "New Employee") |> render_click() =~
               "New Employee"

      assert_patch(index_live, Routes.employee_index_path(conn, :new))

      assert index_live
             |> form("#employee-form", employee: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#employee-form", employee: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.employee_index_path(conn, :index))

      assert html =~ "Employee created successfully"
      assert html =~ "some full_name"
    end

    test "updates employee in listing", %{conn: conn, employee: employee} do
      {:ok, index_live, _html} = live(conn, Routes.employee_index_path(conn, :index))

      assert index_live |> element("#employee-#{employee.id} a", "Edit") |> render_click() =~
               "Edit Employee"

      assert_patch(index_live, Routes.employee_index_path(conn, :edit, employee))

      assert index_live
             |> form("#employee-form", employee: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#employee-form", employee: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.employee_index_path(conn, :index))

      assert html =~ "Employee updated successfully"
      assert html =~ "some updated full_name"
    end

    test "deletes employee in listing", %{conn: conn, employee: employee} do
      {:ok, index_live, _html} = live(conn, Routes.employee_index_path(conn, :index))

      assert index_live |> element("#employee-#{employee.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#employee-#{employee.id}")
    end
  end

  describe "Show" do
    setup [:create_employee]

    test "displays employee", %{conn: conn, employee: employee} do
      {:ok, _show_live, html} = live(conn, Routes.employee_show_path(conn, :show, employee))

      assert html =~ "Show Employee"
      assert html =~ employee.full_name
    end

    test "updates employee within modal", %{conn: conn, employee: employee} do
      {:ok, show_live, _html} = live(conn, Routes.employee_show_path(conn, :show, employee))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Employee"

      assert_patch(show_live, Routes.employee_show_path(conn, :edit, employee))

      assert show_live
             |> form("#employee-form", employee: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#employee-form", employee: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.employee_show_path(conn, :show, employee))

      assert html =~ "Employee updated successfully"
      assert html =~ "some updated full_name"
    end
  end
end
