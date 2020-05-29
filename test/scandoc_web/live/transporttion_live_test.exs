defmodule ScandocWeb.TransporttionLiveTest do
  use ScandocWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Scandoc.Tables

  @create_attrs %{
    company_address: "some company_address",
    company_name: "some company_name",
    remarks: "some remarks"
  }
  @update_attrs %{
    company_address: "some updated company_address",
    company_name: "some updated company_name",
    remarks: "some updated remarks"
  }
  @invalid_attrs %{company_address: nil, company_name: nil, remarks: nil}

  defp fixture(:transporttion) do
    {:ok, transporttion} = Tables.create_transporttion(@create_attrs)
    transporttion
  end

  defp create_transporttion(_) do
    transporttion = fixture(:transporttion)
    %{transporttion: transporttion}
  end

  describe "Index" do
    setup [:create_transporttion]

    test "lists all stransportations", %{conn: conn, transporttion: transporttion} do
      {:ok, _index_live, html} = live(conn, Routes.transporttion_index_path(conn, :index))

      assert html =~ "Listing Stransportations"
      assert html =~ transporttion.company_address
    end

    test "saves new transporttion", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.transporttion_index_path(conn, :index))

      assert index_live |> element("a", "New Transporttion") |> render_click() =~
               "New Transporttion"

      assert_patch(index_live, Routes.transporttion_index_path(conn, :new))

      assert index_live
             |> form("#transporttion-form", transporttion: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#transporttion-form", transporttion: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.transporttion_index_path(conn, :index))

      assert html =~ "Transporttion created successfully"
      assert html =~ "some company_address"
    end

    test "updates transporttion in listing", %{conn: conn, transporttion: transporttion} do
      {:ok, index_live, _html} = live(conn, Routes.transporttion_index_path(conn, :index))

      assert index_live
             |> element("#transporttion-#{transporttion.id} a", "Edit")
             |> render_click() =~
               "Edit Transporttion"

      assert_patch(index_live, Routes.transporttion_index_path(conn, :edit, transporttion))

      assert index_live
             |> form("#transporttion-form", transporttion: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#transporttion-form", transporttion: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.transporttion_index_path(conn, :index))

      assert html =~ "Transporttion updated successfully"
      assert html =~ "some updated company_address"
    end

    test "deletes transporttion in listing", %{conn: conn, transporttion: transporttion} do
      {:ok, index_live, _html} = live(conn, Routes.transporttion_index_path(conn, :index))

      assert index_live
             |> element("#transporttion-#{transporttion.id} a", "Delete")
             |> render_click()

      refute has_element?(index_live, "#transporttion-#{transporttion.id}")
    end
  end

  describe "Show" do
    setup [:create_transporttion]

    test "displays transporttion", %{conn: conn, transporttion: transporttion} do
      {:ok, _show_live, html} =
        live(conn, Routes.transporttion_show_path(conn, :show, transporttion))

      assert html =~ "Show Transporttion"
      assert html =~ transporttion.company_address
    end

    test "updates transporttion within modal", %{conn: conn, transporttion: transporttion} do
      {:ok, show_live, _html} =
        live(conn, Routes.transporttion_show_path(conn, :show, transporttion))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Transporttion"

      assert_patch(show_live, Routes.transporttion_show_path(conn, :edit, transporttion))

      assert show_live
             |> form("#transporttion-form", transporttion: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#transporttion-form", transporttion: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.transporttion_show_path(conn, :show, transporttion))

      assert html =~ "Transporttion updated successfully"
      assert html =~ "some updated company_address"
    end
  end
end
