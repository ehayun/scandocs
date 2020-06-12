defmodule Scandoc.Student.Show.Details do
  # If you generated an app with mix phx.new --live,
  # the line below would be: use MyAppWeb, :live_component
  use Phoenix.LiveComponent
  import ScandocWeb.Gettext

  def render(assigns) do
    ~L"""
    <table class="table">
      <tbody>
      <tr>
        <td><%= gettext("Full name") %></td>
        <td><%= @student.full_name %></td>
      </tr>
      <tr>
        <td><%= gettext("Zehut") %></td>
        <td><%= @student.student_zehut %></td>
      </tr>
      <tr>
        <td><%= gettext("Birthday") %></td>
        <td><%= displayDate(@student.birthdate) %>, <%= @student.hebrew_birthdate %> , <%= gettext("Person Age") %> <%= getAge(@student.birthdate) %></td>
      </tr>
      <tr>
        <td><%= gettext("Address") %></td>
        <td><%= @student.address %>, <%= if @student.city, do: @student.city.title %></td>
      </tr>
      <tr>
        <td><%= gettext("Father name") %></td>
        <td><%= @student.father_name %> (<%= @student.father_zehut %>)</td>
      </tr>
       <tr>
        <td><%= gettext("Mother name") %></td>
        <td><%= @student.mother_name %> (<%= @student.mother_zehut %>)</td>
      </tr>
      <tr>
        <td><%= gettext("Healthcare name") %></td>
        <td><%= @student.healthcare %></td>
      </tr>
      </tbody>
    </table>

    """
  end
  def displayDate(dt, dmy \\ "%d/%m/%Y") do
    case dt
         |> Calendar.Strftime.strftime(dmy) do
      {:ok, d} -> d
      _ -> dt
    end
  end

  def getAge(dob) do
    if dob do
      {:ok, y} = dob
                 |> Calendar.Strftime.strftime("%Y")
      {:ok, cy} = Calendar.Date.today_utc()
                  |> Calendar.Strftime.strftime("%Y")

      String.to_integer(cy) - String.to_integer(y)
    else
      ""
    end
  end

end