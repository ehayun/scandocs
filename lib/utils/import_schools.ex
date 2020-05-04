defmodule Scandoc.Util.ImportSchools do
  alias Scandoc.Schools
  alias Scandoc.Schools.{School, Manager}
  alias Scandoc.Repo

  def run() do
    # calling our Hello.say() function from earlier
    IO.puts("import schools")

    getFiles("/home/eli/pCloudDrive/Scan_files/")
  end

  defp getFiles(root) do
    files = Path.wildcard("#{root}/*")
    files |> Enum.each(fn file -> addToSchools(file) end)
  end

  defp addToSchools(file) do
    # IO.puts(file)
    f = Path.basename(file)

    if f != "Program" && f != "קודים" do
      if File.dir?(file) do
        # res = Regex.scan(~r/[0-9]+.*$/, f)
        # IO.inspect(res, label: "[#{f}]")

        case Regex.scan(~r/[0-9]+.*$/, f) do
          [] ->
            if f != "חכמת_ישראל" do
              addSchool(f)
            end

          _ ->
            nil
        end

        getFiles(file)
      end
    end
  end

  defp getManager do
    m =
      case Schools.list_teachers() do
        [] ->
          nil

        m ->
          m
      end

    case m do
      nil ->
        nil

      m ->
        c = Enum.count(m)
        m = m |> Enum.at(Enum.random(0..c))
        m = Schools.get_teacher!(m.id)
        Schools.update_teacher(m, %{role: "020"})
        m.id
    end
  end

  defp addSchool(school_name) do
    if Schools.get_school_by_name(school_name) do
    else
      m = getManager()
      c = School |> Repo.aggregate(:count)
      c = c + 500

      rec = %{
        school_name: school_name,
        code: "#{c}",
        manager_id: m
      }

      Schools.create_school(rec)
      IO.inspect(rec)

      IO.puts("adding #{school_name}")
    end
  end

  # EOF
end
