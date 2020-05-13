defmodule ScandocWeb.SchoolView do
  use ScandocWeb, :view

  alias Scandoc.Schools

  def getTeacherName(id) do
    t = Schools.get_teacher!(id)
    t.full_name
  end
end
