defmodule ScandocWeb.InstdocLiveTest do
  use ScandocWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Scandoc.Institutes

  @create_attrs %{amount: "120.5", category_id: 42, code: "some code", doc_date: ~D[2010-04-17], doc_name: "some doc_name", doc_path: "some doc_path", line_code: "some line_code", outcome_category_id: 42, payment_code: "some payment_code", vendor_id: 42}
  @update_attrs %{amount: "456.7", category_id: 43, code: "some updated code", doc_date: ~D[2011-05-18], doc_name: "some updated doc_name", doc_path: "some updated doc_path", line_code: "some updated line_code", outcome_category_id: 43, payment_code: "some updated payment_code", vendor_id: 43}
  @invalid_attrs %{amount: nil, category_id: nil, code: nil, doc_date: nil, doc_name: nil, doc_path: nil, line_code: nil, outcome_category_id: nil, payment_code: nil, vendor_id: nil}

  defp fixture(:instdoc) do
    {:ok, instdoc} = Institutes.create_instdoc(@create_attrs)
    instdoc
  end

  defp create_instdoc(_) do
    instdoc = fixture(:instdoc)
    %{instdoc: instdoc}
  end

  describe "Index" do
    setup [:create_instdoc]

    test "lists all inst_docs", %{conn: conn, instdoc: instdoc} do
      {:ok, _index_live, html} = live(conn, Routes.instdoc_index_path(conn, :index))

      assert html =~ "Listing Inst docs"
      assert html =~ instdoc.code
    end

    test "saves new instdoc", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.instdoc_index_path(conn, :index))

      assert index_live |> element("a", "New Instdoc") |> render_click() =~
        "New Instdoc"

      assert_patch(index_live, Routes.instdoc_index_path(conn, :new))

      assert index_live
             |> form("#instdoc-form", instdoc: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#instdoc-form", instdoc: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.instdoc_index_path(conn, :index))

      assert html =~ "Instdoc created successfully"
      assert html =~ "some code"
    end

    test "updates instdoc in listing", %{conn: conn, instdoc: instdoc} do
      {:ok, index_live, _html} = live(conn, Routes.instdoc_index_path(conn, :index))

      assert index_live |> element("#instdoc-#{instdoc.id} a", "Edit") |> render_click() =~
        "Edit Instdoc"

      assert_patch(index_live, Routes.instdoc_index_path(conn, :edit, instdoc))

      assert index_live
             |> form("#instdoc-form", instdoc: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#instdoc-form", instdoc: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.instdoc_index_path(conn, :index))

      assert html =~ "Instdoc updated successfully"
      assert html =~ "some updated code"
    end

    test "deletes instdoc in listing", %{conn: conn, instdoc: instdoc} do
      {:ok, index_live, _html} = live(conn, Routes.instdoc_index_path(conn, :index))

      assert index_live |> element("#instdoc-#{instdoc.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#instdoc-#{instdoc.id}")
    end
  end

  describe "Show" do
    setup [:create_instdoc]

    test "displays instdoc", %{conn: conn, instdoc: instdoc} do
      {:ok, _show_live, html} = live(conn, Routes.instdoc_show_path(conn, :show, instdoc))

      assert html =~ "Show Instdoc"
      assert html =~ instdoc.code
    end

    test "updates instdoc within modal", %{conn: conn, instdoc: instdoc} do
      {:ok, show_live, _html} = live(conn, Routes.instdoc_show_path(conn, :show, instdoc))

      assert show_live |> element("a", "Edit") |> render_click() =~
        "Edit Instdoc"

      assert_patch(show_live, Routes.instdoc_show_path(conn, :edit, instdoc))

      assert show_live
             |> form("#instdoc-form", instdoc: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#instdoc-form", instdoc: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.instdoc_show_path(conn, :show, instdoc))

      assert html =~ "Instdoc updated successfully"
      assert html =~ "some updated code"
    end
  end
end
