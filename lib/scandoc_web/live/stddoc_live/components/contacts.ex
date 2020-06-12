defmodule Scandoc.Student.Show.Contacts do
  # If you generated an app with mix phx.new --live,
  # the line below would be: use MyAppWeb, :live_component
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
    <table class="table">
      <tbody>
      <%= for c <- @student.contacts do %>
      <tr>
        <td><%= c.contact_name %></td>
        <td><%= tr c.contact_type %></td>
        <td><%= c.contact_value %></td>
        <td><%= c.remark %></td>
      </tr>
    <% end %>
      </tbody>
    </table>

    """
  end

  def tr(txt) do
    Gettext.dgettext(ScandocWeb.Gettext, "default", txt)
  end
end