defmodule ScandocWeb.LayoutView do
  use ScandocWeb, :view

  def active_menu(conn, item) do
    if conn.request_path =~ to_string(item) do
      "active"
    else
      ""
    end
  end
end
