defmodule ScandocWeb.StddocLiveTest do
  use ScandocWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Scandoc.Students

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp fixture(:stddoc) do
    {:ok, stddoc} = Students.create_stddoc(@create_attrs)
    stddoc
  end

  defp create_stddoc(_) do
    stddoc = fixture(:stddoc)
    %{stddoc: stddoc}
  end

  describe "Index" do
    setup [:create_stddoc]

    test "lists all stddocs", %{conn: conn, stddoc: stddoc} do
      {:ok, _index_live, html} = live(conn, Routes.stddoc_index_path(conn, :index))

      assert html =~ "Listing Stddocs"
    end

    test "saves new stddoc", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.stddoc_index_path(conn, :index))

      assert index_live |> element("a", "New Stddoc") |> render_click() =~
               "New Stddoc"

      assert_patch(index_live, Routes.stddoc_index_path(conn, :new))

      assert index_live
             |> form("#stddoc-form", stddoc: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#stddoc-form", stddoc: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.stddoc_index_path(conn, :index))

      assert html =~ "Stddoc created successfully"
    end

    test "updates stddoc in listing", %{conn: conn, stddoc: stddoc} do
      {:ok, index_live, _html} = live(conn, Routes.stddoc_index_path(conn, :index))

      assert index_live |> element("#stddoc-#{stddoc.id} a", "Edit") |> render_click() =~
               "Edit Stddoc"

      assert_patch(index_live, Routes.stddoc_index_path(conn, :edit, stddoc))

      assert index_live
             |> form("#stddoc-form", stddoc: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#stddoc-form", stddoc: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.stddoc_index_path(conn, :index))

      assert html =~ "Stddoc updated successfully"
    end

    test "deletes stddoc in listing", %{conn: conn, stddoc: stddoc} do
      {:ok, index_live, _html} = live(conn, Routes.stddoc_index_path(conn, :index))

      assert index_live |> element("#stddoc-#{stddoc.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#stddoc-#{stddoc.id}")
    end
  end

  describe "Show" do
    setup [:create_stddoc]

    test "displays stddoc", %{conn: conn, stddoc: stddoc} do
      {:ok, _show_live, html} = live(conn, Routes.stddoc_show_path(conn, :show, stddoc))

      assert html =~ "Show Stddoc"
    end

    test "updates stddoc within modal", %{conn: conn, stddoc: stddoc} do
      {:ok, show_live, _html} = live(conn, Routes.stddoc_show_path(conn, :show, stddoc))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Stddoc"

      assert_patch(show_live, Routes.stddoc_show_path(conn, :edit, stddoc))

      assert show_live
             |> form("#stddoc-form", stddoc: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#stddoc-form", stddoc: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.stddoc_show_path(conn, :show, stddoc))

      assert html =~ "Stddoc updated successfully"
    end
  end
end
