defmodule Scandoc.Util.ImportClassrooms do
  alias Scandoc.Schools
  alias Scandoc.Classrooms

  def run() do
    # calling our Hello.say() function from earlier

    code = 400

    schools = Schools.list_schools()

    schools
    |> Enum.each(fn school ->
      n = Enum.random(1..100)

      1..n
      |> Enum.each(fn idx ->
        Classrooms.create_classroom(%{
          code: "#{code + school.id + idx}",
          classroom_name: "כיתה #{code + school.id + idx}",
          school_id: school.id,
          teacher_id: getTeacher()
        })
      end)
    end)
  end

  defp getTeacher() do
    teachers = Schools.list_teachers()
    c = teachers |> Enum.count()

    idx = Enum.random(0..(c - 1))

    t = teachers |> Enum.at(idx)

    t.id
  end

  # eof
end
