defmodule ScandocWeb.OutcomeCategoryLiveTest do
  use ScandocWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Scandoc.Categories

  @create_attrs %{category_id: 42, outcome_card: "some outcome_card", outcome_description: "some outcome_description"}
  @update_attrs %{category_id: 43, outcome_card: "some updated outcome_card", outcome_description: "some updated outcome_description"}
  @invalid_attrs %{category_id: nil, outcome_card: nil, outcome_description: nil}

  defp fixture(:outcome_category) do
    {:ok, outcome_category} = Categories.create_outcome_category(@create_attrs)
    outcome_category
  end

  defp create_outcome_category(_) do
    outcome_category = fixture(:outcome_category)
    %{outcome_category: outcome_category}
  end

  describe "Index" do
    setup [:create_outcome_category]

    test "lists all outcome_categoryes", %{conn: conn, outcome_category: outcome_category} do
      {:ok, _index_live, html} = live(conn, Routes.outcome_category_index_path(conn, :index))

      assert html =~ "Listing Outcome categoryes"
      assert html =~ outcome_category.outcome_card
    end

    test "saves new outcome_category", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.outcome_category_index_path(conn, :index))

      assert index_live |> element("a", "New Outcome category") |> render_click() =~
        "New Outcome category"

      assert_patch(index_live, Routes.outcome_category_index_path(conn, :new))

      assert index_live
             |> form("#outcome_category-form", outcome_category: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#outcome_category-form", outcome_category: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.outcome_category_index_path(conn, :index))

      assert html =~ "Outcome category created successfully"
      assert html =~ "some outcome_card"
    end

    test "updates outcome_category in listing", %{conn: conn, outcome_category: outcome_category} do
      {:ok, index_live, _html} = live(conn, Routes.outcome_category_index_path(conn, :index))

      assert index_live |> element("#outcome_category-#{outcome_category.id} a", "Edit") |> render_click() =~
        "Edit Outcome category"

      assert_patch(index_live, Routes.outcome_category_index_path(conn, :edit, outcome_category))

      assert index_live
             |> form("#outcome_category-form", outcome_category: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#outcome_category-form", outcome_category: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.outcome_category_index_path(conn, :index))

      assert html =~ "Outcome category updated successfully"
      assert html =~ "some updated outcome_card"
    end

    test "deletes outcome_category in listing", %{conn: conn, outcome_category: outcome_category} do
      {:ok, index_live, _html} = live(conn, Routes.outcome_category_index_path(conn, :index))

      assert index_live |> element("#outcome_category-#{outcome_category.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#outcome_category-#{outcome_category.id}")
    end
  end

  describe "Show" do
    setup [:create_outcome_category]

    test "displays outcome_category", %{conn: conn, outcome_category: outcome_category} do
      {:ok, _show_live, html} = live(conn, Routes.outcome_category_show_path(conn, :show, outcome_category))

      assert html =~ "Show Outcome category"
      assert html =~ outcome_category.outcome_card
    end

    test "updates outcome_category within modal", %{conn: conn, outcome_category: outcome_category} do
      {:ok, show_live, _html} = live(conn, Routes.outcome_category_show_path(conn, :show, outcome_category))

      assert show_live |> element("a", "Edit") |> render_click() =~
        "Edit Outcome category"

      assert_patch(show_live, Routes.outcome_category_show_path(conn, :edit, outcome_category))

      assert show_live
             |> form("#outcome_category-form", outcome_category: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#outcome_category-form", outcome_category: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.outcome_category_show_path(conn, :show, outcome_category))

      assert html =~ "Outcome category updated successfully"
      assert html =~ "some updated outcome_card"
    end
  end
end
