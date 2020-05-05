defmodule ScandocWeb.Permissions.PermissionLiveTest do
  use ScandocWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Scandoc.Permissions

  @create_attrs %{permission_type: 42, ref_id: 42, user_id: 42}
  @update_attrs %{permission_type: 43, ref_id: 43, user_id: 43}
  @invalid_attrs %{permission_type: nil, ref_id: nil, user_id: nil}

  defp fixture(:permission) do
    {:ok, permission} = Permissions.create_permission(@create_attrs)
    permission
  end

  defp create_permission(_) do
    permission = fixture(:permission)
    %{permission: permission}
  end

  describe "Index" do
    setup [:create_permission]

    test "lists all permissions", %{conn: conn, permission: permission} do
      {:ok, _index_live, html} = live(conn, Routes.permissions_permission_index_path(conn, :index))

      assert html =~ "Listing Permissions"
    end

    test "saves new permission", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.permissions_permission_index_path(conn, :index))

      assert index_live |> element("a", "New Permission") |> render_click() =~
        "New Permission"

      assert_patch(index_live, Routes.permissions_permission_index_path(conn, :new))

      assert index_live
             |> form("#permission-form", permission: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#permission-form", permission: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.permissions_permission_index_path(conn, :index))

      assert html =~ "Permission created successfully"
    end

    test "updates permission in listing", %{conn: conn, permission: permission} do
      {:ok, index_live, _html} = live(conn, Routes.permissions_permission_index_path(conn, :index))

      assert index_live |> element("#permission-#{permission.id} a", "Edit") |> render_click() =~
        "Edit Permission"

      assert_patch(index_live, Routes.permissions_permission_index_path(conn, :edit, permission))

      assert index_live
             |> form("#permission-form", permission: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#permission-form", permission: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.permissions_permission_index_path(conn, :index))

      assert html =~ "Permission updated successfully"
    end

    test "deletes permission in listing", %{conn: conn, permission: permission} do
      {:ok, index_live, _html} = live(conn, Routes.permissions_permission_index_path(conn, :index))

      assert index_live |> element("#permission-#{permission.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#permission-#{permission.id}")
    end
  end

  describe "Show" do
    setup [:create_permission]

    test "displays permission", %{conn: conn, permission: permission} do
      {:ok, _show_live, html} = live(conn, Routes.permissions_permission_show_path(conn, :show, permission))

      assert html =~ "Show Permission"
    end

    test "updates permission within modal", %{conn: conn, permission: permission} do
      {:ok, show_live, _html} = live(conn, Routes.permissions_permission_show_path(conn, :show, permission))

      assert show_live |> element("a", "Edit") |> render_click() =~
        "Edit Permission"

      assert_patch(show_live, Routes.permissions_permission_show_path(conn, :edit, permission))

      assert show_live
             |> form("#permission-form", permission: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#permission-form", permission: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.permissions_permission_show_path(conn, :show, permission))

      assert html =~ "Permission updated successfully"
    end
  end
end
