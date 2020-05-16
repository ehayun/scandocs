defmodule ScandocWeb.InstituteLiveTest do
  use ScandocWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Scandoc.Institutes

  @create_attrs %{code: "some code", title: "some title"}
  @update_attrs %{code: "some updated code", title: "some updated title"}
  @invalid_attrs %{code: nil, title: nil}

  defp fixture(:institute) do
    {:ok, institute} = Institutes.create_institute(@create_attrs)
    institute
  end

  defp create_institute(_) do
    institute = fixture(:institute)
    %{institute: institute}
  end

  describe "Index" do
    setup [:create_institute]

    test "lists all institutes", %{conn: conn, institute: institute} do
      {:ok, _index_live, html} = live(conn, Routes.institute_index_path(conn, :index))

      assert html =~ "Listing Institutes"
      assert html =~ institute.code
    end

    test "saves new institute", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.institute_index_path(conn, :index))

      assert index_live |> element("a", "New Institute") |> render_click() =~
               "New Institute"

      assert_patch(index_live, Routes.institute_index_path(conn, :new))

      assert index_live
             |> form("#institute-form", institute: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#institute-form", institute: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.institute_index_path(conn, :index))

      assert html =~ "Institute created successfully"
      assert html =~ "some code"
    end

    test "updates institute in listing", %{conn: conn, institute: institute} do
      {:ok, index_live, _html} = live(conn, Routes.institute_index_path(conn, :index))

      assert index_live |> element("#institute-#{institute.id} a", "Edit") |> render_click() =~
               "Edit Institute"

      assert_patch(index_live, Routes.institute_index_path(conn, :edit, institute))

      assert index_live
             |> form("#institute-form", institute: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#institute-form", institute: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.institute_index_path(conn, :index))

      assert html =~ "Institute updated successfully"
      assert html =~ "some updated code"
    end

    test "deletes institute in listing", %{conn: conn, institute: institute} do
      {:ok, index_live, _html} = live(conn, Routes.institute_index_path(conn, :index))

      assert index_live |> element("#institute-#{institute.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#institute-#{institute.id}")
    end
  end

  describe "Show" do
    setup [:create_institute]

    test "displays institute", %{conn: conn, institute: institute} do
      {:ok, _show_live, html} = live(conn, Routes.institute_show_path(conn, :show, institute))

      assert html =~ "Show Institute"
      assert html =~ institute.code
    end

    test "updates institute within modal", %{conn: conn, institute: institute} do
      {:ok, show_live, _html} = live(conn, Routes.institute_show_path(conn, :show, institute))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Institute"

      assert_patch(show_live, Routes.institute_show_path(conn, :edit, institute))

      assert show_live
             |> form("#institute-form", institute: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#institute-form", institute: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.institute_show_path(conn, :show, institute))

      assert html =~ "Institute updated successfully"
      assert html =~ "some updated code"
    end
  end
end
