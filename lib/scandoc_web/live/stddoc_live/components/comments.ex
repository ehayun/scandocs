defmodule Scandoc.Student.Show.Comments do
  # If you generated an app with mix phx.new --live,
  # the line below would be: use MyAppWeb, :live_component
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
    <table class="table">
      <tbody>
      <%= for c <- @student.comments do %>
      <tr>
        <td><%= if c.done, do: tr("Done") %></td>
        <td><%= displayDate c.comment_date %></td>
        <td><%= c.comment %></td>
      </tr>
    <% end %>
      </tbody>
    </table>

    """
  end

  def tr(txt) do
    Gettext.dgettext(ScandocWeb.Gettext, "default", txt)
  end

  def displayDate(dt, dmy \\ "%d/%m/%Y") do
    case dt
         |> Calendar.Strftime.strftime(dmy) do
      {:ok, d} -> d
      _ -> dt
    end
  end
end
