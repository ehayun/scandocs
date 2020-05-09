defmodule ScandocWeb.DocgroupLiveTest do
  use ScandocWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Scandoc.Documents

  @create_attrs %{grp_name: "some grp_name"}
  @update_attrs %{grp_name: "some updated grp_name"}
  @invalid_attrs %{grp_name: nil}

  defp fixture(:docgroup) do
    {:ok, docgroup} = Documents.create_docgroup(@create_attrs)
    docgroup
  end

  defp create_docgroup(_) do
    docgroup = fixture(:docgroup)
    %{docgroup: docgroup}
  end

  describe "Index" do
    setup [:create_docgroup]

    test "lists all docgroups", %{conn: conn, docgroup: docgroup} do
      {:ok, _index_live, html} = live(conn, Routes.docgroup_index_path(conn, :index))

      assert html =~ "Listing Docgroups"
      assert html =~ docgroup.grp_name
    end

    test "saves new docgroup", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.docgroup_index_path(conn, :index))

      assert index_live |> element("a", "New Docgroup") |> render_click() =~
               "New Docgroup"

      assert_patch(index_live, Routes.docgroup_index_path(conn, :new))

      assert index_live
             |> form("#docgroup-form", docgroup: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#docgroup-form", docgroup: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.docgroup_index_path(conn, :index))

      assert html =~ "Docgroup created successfully"
      assert html =~ "some grp_name"
    end

    test "updates docgroup in listing", %{conn: conn, docgroup: docgroup} do
      {:ok, index_live, _html} = live(conn, Routes.docgroup_index_path(conn, :index))

      assert index_live |> element("#docgroup-#{docgroup.id} a", "Edit") |> render_click() =~
               "Edit Docgroup"

      assert_patch(index_live, Routes.docgroup_index_path(conn, :edit, docgroup))

      assert index_live
             |> form("#docgroup-form", docgroup: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#docgroup-form", docgroup: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.docgroup_index_path(conn, :index))

      assert html =~ "Docgroup updated successfully"
      assert html =~ "some updated grp_name"
    end

    test "deletes docgroup in listing", %{conn: conn, docgroup: docgroup} do
      {:ok, index_live, _html} = live(conn, Routes.docgroup_index_path(conn, :index))

      assert index_live |> element("#docgroup-#{docgroup.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#docgroup-#{docgroup.id}")
    end
  end

  describe "Show" do
    setup [:create_docgroup]

    test "displays docgroup", %{conn: conn, docgroup: docgroup} do
      {:ok, _show_live, html} = live(conn, Routes.docgroup_show_path(conn, :show, docgroup))

      assert html =~ "Show Docgroup"
      assert html =~ docgroup.grp_name
    end

    test "updates docgroup within modal", %{conn: conn, docgroup: docgroup} do
      {:ok, show_live, _html} = live(conn, Routes.docgroup_show_path(conn, :show, docgroup))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Docgroup"

      assert_patch(show_live, Routes.docgroup_show_path(conn, :edit, docgroup))

      assert show_live
             |> form("#docgroup-form", docgroup: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#docgroup-form", docgroup: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.docgroup_show_path(conn, :show, docgroup))

      assert html =~ "Docgroup updated successfully"
      assert html =~ "some updated grp_name"
    end
  end
end
