defmodule Scandoc.Util.ImportStudents do
  import Ecto.Query
  alias Scandoc.Repo

  alias Scandoc.Students.Student
  alias Scandoc.Documents.Doctype
  alias Scandoc.Schools
  alias Scandoc.Schools.School
  alias Scandoc.Classrooms.Classroom
  alias Scandoc.Documents
  alias Scandoc.Documents.Document

  def run() do
    # calling our Hello.say() function from earlier

    sc = School |> Repo.all()

    sc
    |> Enum.each(fn s ->
      name = String.replace(s.school_name, "_", " ")
      Schools.update_school(s, %{school_name: name})
    end)

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

        # case Regex.scan(~r/[0-9]+.*$/, f) do
        #   [] ->
        #     if f != "חכמת_ישראל" do
        #     end

        #     nil

        #   _ ->
        #     addStudent(f, file)
        # end

        getFiles(file)
      else
        addDocument(f, file)
      end
    end
  end

  defp addDocument(f, file) do
    doc_path = Path.rootname(file)
    doc_name = Path.basename(file)

    student_id = getStudent(doc_path)
    just_name = Path.rootname(doc_name)

    [_zehut, _type, yymm] =
      case String.split(just_name, "-") do
        [zehut, type, yymm] -> [zehut, type, yymm]
        _ -> [nil, nil, nil]
      end

    [yy, mm] =
      if yymm do
        [_, yy, mm] = Regex.run(~r/(..)(..)/, yymm)
        [yy, mm]
      else
        ["0", "0"]
      end

    params = %{
      line_code: "#{Enum.random(20000..25000)}",
      doc_name: doc_name,
      doc_path: file,
      doc_name_len: String.length(doc_name),
      ref_id: student_id,
      ref_year: yy,
      ref_month: mm,
      doctype_id: getDoctype(doc_name)
    }

    case Document |> where(doc_name: ^doc_name) |> where(doc_path: ^doc_path) |> Repo.one() do
      nil ->
        Documents.create_document(params)

      doc ->
        Documents.update_document(doc, params)
    end
  end

  # defp addStudent(f, file) do
  #   # IO.puts("Student #{f} as: #{file}")
  # end

  defp getDoctype(file) do
    # IO.inspect(file, label: "doctype")
    std = Path.basename(file, Path.extname(file))

    [_zehut, doc_type, _yymm] =
      case String.split(std, "-") do
        [zehut, doc_type, yymm] ->
          [zehut, doc_type, yymm]

        [zehut] ->
          [zehut, nil, nil]

        _ ->
          [nil, nil, nil]
      end

    if doc_type do
      case Doctype |> where(code: ^doc_type) |> Repo.one() do
        nil ->
          {:ok, doc} =
            Documents.create_doctype(%{code: "#{doc_type}", doc_name: "Unknown #{doc_type}"})

          doc.id

        doc ->
          doc.id
      end
    else
      doc_type = Enum.random(1000..3000)

      {:ok, doc} =
        Documents.create_doctype(%{code: "#{doc_type}", doc_name: "Unknown #{doc_type}"})

      doc.id
    end
  end

  defp getStudent(path) do
    ll = String.split(path, "/")

    cc = Enum.count(ll)
    std = ll |> Enum.at(cc - 2)
    z_n = String.split(std, "_")
    cc = Enum.count(z_n)
    zehut = z_n |> Enum.at(cc - 1)
    # z_n |> Enum.each(fn z -> IO.inspect(z) end)
    std = String.replace(std, zehut, "")
    std_name = String.replace(std, "_", " ")

    case Student |> where(student_zehut: ^zehut) |> Repo.one() do
      nil ->
        cls = getClassroom(path)

        if cls do
          student = %{
            student_zehut: zehut,
            full_name: std_name,
            classroom_id: cls
          }

          case Scandoc.Students.create_student(student) do
            {:ok, std} ->
              std.id

            _ ->
              nil
          end
        else
          nil
        end

      std ->
        std.id
    end
  end

  defp getClassroom(path) do
    paths = String.split(path, "/")
    cc = Enum.count(paths)

    school_name = paths |> Enum.at(cc - 3)

    school_name = String.replace(school_name, "_", " ")

    school_id =
      case School |> where(school_name: ^school_name) |> Repo.one() do
        nil -> nil
        school -> school.id
      end

    if school_id do
      classrooms = Classroom |> where(school_id: ^school_id) |> Repo.all()

      case classrooms do
        [] ->
          nil

        classrooms ->
          cc = Enum.count(classrooms)
          idx = Enum.random(0..cc)
          cls = classrooms |> Enum.at(idx)
          cls.id
      end
    else
      nil
    end
  end

  # EOF
end
