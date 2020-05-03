defmodule ScandocWeb.PhoneLiveTest do
  use ScandocWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Scandoc.Customers

  @create_attrs %{google_account: "some google_account", google_ref_token: "some google_ref_token", google_token: "some google_token", note: "some note", phonenum: "some phonenum", provider_token: "some provider_token", provider_unique_id: "some provider_unique_id", provider_url: "some provider_url", sendertype: "some sendertype", title: "some title", user_id: "some user_id"}
  @update_attrs %{google_account: "some updated google_account", google_ref_token: "some updated google_ref_token", google_token: "some updated google_token", note: "some updated note", phonenum: "some updated phonenum", provider_token: "some updated provider_token", provider_unique_id: "some updated provider_unique_id", provider_url: "some updated provider_url", sendertype: "some updated sendertype", title: "some updated title", user_id: "some updated user_id"}
  @invalid_attrs %{google_account: nil, google_ref_token: nil, google_token: nil, note: nil, phonenum: nil, provider_token: nil, provider_unique_id: nil, provider_url: nil, sendertype: nil, title: nil, user_id: nil}

  defp fixture(:phone) do
    {:ok, phone} = Customers.create_phone(@create_attrs)
    phone
  end

  defp create_phone(_) do
    phone = fixture(:phone)
    %{phone: phone}
  end

  describe "Index" do
    setup [:create_phone]

    test "lists all phones", %{conn: conn, phone: phone} do
      {:ok, _index_live, html} = live(conn, Routes.phone_index_path(conn, :index))

      assert html =~ "Listing Phones"
      assert html =~ phone.google_account
    end

    test "saves new phone", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.phone_index_path(conn, :index))

      assert index_live |> element("a", "New Phone") |> render_click() =~
        "New Phone"

      assert_patch(index_live, Routes.phone_index_path(conn, :new))

      assert index_live
             |> form("#phone-form", phone: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#phone-form", phone: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.phone_index_path(conn, :index))

      assert html =~ "Phone created successfully"
      assert html =~ "some google_account"
    end

    test "updates phone in listing", %{conn: conn, phone: phone} do
      {:ok, index_live, _html} = live(conn, Routes.phone_index_path(conn, :index))

      assert index_live |> element("#phone-#{phone.id} a", "Edit") |> render_click() =~
        "Edit Phone"

      assert_patch(index_live, Routes.phone_index_path(conn, :edit, phone))

      assert index_live
             |> form("#phone-form", phone: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#phone-form", phone: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.phone_index_path(conn, :index))

      assert html =~ "Phone updated successfully"
      assert html =~ "some updated google_account"
    end

    test "deletes phone in listing", %{conn: conn, phone: phone} do
      {:ok, index_live, _html} = live(conn, Routes.phone_index_path(conn, :index))

      assert index_live |> element("#phone-#{phone.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#phone-#{phone.id}")
    end
  end

  describe "Show" do
    setup [:create_phone]

    test "displays phone", %{conn: conn, phone: phone} do
      {:ok, _show_live, html} = live(conn, Routes.phone_show_path(conn, :show, phone))

      assert html =~ "Show Phone"
      assert html =~ phone.google_account
    end

    test "updates phone within modal", %{conn: conn, phone: phone} do
      {:ok, show_live, _html} = live(conn, Routes.phone_show_path(conn, :show, phone))

      assert show_live |> element("a", "Edit") |> render_click() =~
        "Edit Phone"

      assert_patch(show_live, Routes.phone_show_path(conn, :edit, phone))

      assert show_live
             |> form("#phone-form", phone: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#phone-form", phone: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.phone_show_path(conn, :show, phone))

      assert html =~ "Phone updated successfully"
      assert html =~ "some updated google_account"
    end
  end
end
