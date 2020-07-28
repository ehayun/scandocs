defmodule Scandoc.Util.Fix do
  @moduledoc """
  Small utility to modify first and last name from full name
  assume that the last word is the last name and the rest is the first name
  """
  import Ecto.Query, warn: false
  alias Scandoc.Repo

  alias Scandoc.Students
  alias Scandoc.Students.Student

  def fix_names do
    stds = from(s in Student, where: is_nil(s.first_name)) |> Repo.all()

    for s <- stds, s.full_name do
      names = String.split(s.full_name)
      last = names |> List.last()
      first = Enum.join(names -- [last], " ")

      attrs = %{
        first_name: first,
        last_name: last
      }

      Students.update_student(s, attrs)
    end

    nil
  end
end
