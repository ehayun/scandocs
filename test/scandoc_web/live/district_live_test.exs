defmodule ScandocWeb.DistrictLiveTest do
  use ScandocWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Scandoc.Tables

  @create_attrs %{district_name: "some district_name"}
  @update_attrs %{district_name: "some updated district_name"}
  @invalid_attrs %{district_name: nil}

  defp fixture(:district) do
    {:ok, district} = Tables.create_district(@create_attrs)
    district
  end

  defp create_district(_) do
    district = fixture(:district)
    %{district: district}
  end

  describe "Index" do
    setup [:create_district]

    test "lists all districts", %{conn: conn, district: district} do
      {:ok, _index_live, html} = live(conn, Routes.district_index_path(conn, :index))

      assert html =~ "Listing Districts"
      assert html =~ district.district_name
    end

    test "saves new district", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.district_index_path(conn, :index))

      assert index_live |> element("a", "New District") |> render_click() =~
               "New District"

      assert_patch(index_live, Routes.district_index_path(conn, :new))

      assert index_live
             |> form("#district-form", district: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#district-form", district: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.district_index_path(conn, :index))

      assert html =~ "District created successfully"
      assert html =~ "some district_name"
    end

    test "updates district in listing", %{conn: conn, district: district} do
      {:ok, index_live, _html} = live(conn, Routes.district_index_path(conn, :index))

      assert index_live |> element("#district-#{district.id} a", "Edit") |> render_click() =~
               "Edit District"

      assert_patch(index_live, Routes.district_index_path(conn, :edit, district))

      assert index_live
             |> form("#district-form", district: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#district-form", district: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.district_index_path(conn, :index))

      assert html =~ "District updated successfully"
      assert html =~ "some updated district_name"
    end

    test "deletes district in listing", %{conn: conn, district: district} do
      {:ok, index_live, _html} = live(conn, Routes.district_index_path(conn, :index))

      assert index_live |> element("#district-#{district.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#district-#{district.id}")
    end
  end

  describe "Show" do
    setup [:create_district]

    test "displays district", %{conn: conn, district: district} do
      {:ok, _show_live, html} = live(conn, Routes.district_show_path(conn, :show, district))

      assert html =~ "Show District"
      assert html =~ district.district_name
    end

    test "updates district within modal", %{conn: conn, district: district} do
      {:ok, show_live, _html} = live(conn, Routes.district_show_path(conn, :show, district))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit District"

      assert_patch(show_live, Routes.district_show_path(conn, :edit, district))

      assert show_live
             |> form("#district-form", district: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#district-form", district: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.district_show_path(conn, :show, district))

      assert html =~ "District updated successfully"
      assert html =~ "some updated district_name"
    end
  end
end
