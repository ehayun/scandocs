defmodule ScandocWeb.LiveHelpers do
  import Phoenix.LiveView.Helpers

  import Ecto.Query
  alias Scandoc.Repo

  alias Scandoc.Permissions
  alias Scandoc.Schools
  alias Scandoc.Schools.School
  alias Scandoc.Classrooms
  alias Scandoc.Classrooms.Classroom
  alias Scandoc.Students.Student
  alias Scandoc.Institutes.Institute
  alias Scandoc.Employees.Role

  alias Scandoc.Documents.Docgroup

  def getDocGroup(id) do
    case Docgroup |> where(id: ^id) |> Repo.one() do
      nil -> ""
      g -> g.grp_name
    end
  end

  def getSchoolName(id, type \\ :school) do
    s =
      case type do
        :school -> Schools.get_school!(id)
        :classroom -> Schools.get_school_by_classroom(id)
        :employee -> Schools.get_school_by_manager(id)
      end

    if s do
      s.school_name
    else
      ""
    end
  end

  def getClassroomName(id, role) do
    school_name =
      case role do
        "020" ->
          s = Schools.get_school_by_manager(id)
          if s, do: s.school_name, else: ""

        "030" ->
          c = Classrooms.get_classroom_by_teacher(id)

          if c do
            s = Schools.get_school!(c.school_id)
            if s, do: s.school_name, else: ""
          else
            ""
          end

        _ ->
          ""
      end

    classroom_name =
      case role do
        "030" ->
          c = Classrooms.get_classroom_by_teacher(id)
          if c, do: c.classroom_name, else: ""

        _ ->
          ""
      end

    slash = if classroom_name > "", do: "/", else: ""

    "#{school_name}#{slash}#{classroom_name}"
  end

  def getDocumentPath(path) do
    if File.exists?("#{path}"),
      do: String.replace(path, "/home/eli/pCloudDrive", "/uploads"),
      else: "#"
  end

  def isTeacher(role) do
    role == "030"
  end

  def isSchoolManager(role) do
    role == "020"
  end

  def displayAmount(amount) do
    Money.to_string(Money.new(trunc(Decimal.to_float(amount) * 100.00)))
  end

  def displayDate(dt) do
    case dt |> Calendar.Strftime.strftime("%d/%m/%Y") do
      {:ok, d} -> d
      _ -> dt
    end
  end

  def displayRole(role) do
    case Role |> where(code: ^role) |> Repo.one() do
      nil -> "???"
      role -> role.title
    end
  end

  def getFluid(socket) do
    %{changed: changed} = socket

    case changed do
      %{instdoc: _} -> "container-fluid"
      _ -> "container"
    end
  end

  @doc """
  Renders a component inside the `ScandocWeb.ModalComponent` component.

  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.

  ## Examples

      <%= live_modal @socket, ScandocWeb.PhoneLive.FormComponent,
        id: @phone.id || :new,
        action: @live_action,
        phone: @phone,
        return_to: Routes.phone_index_path(@socket, :index) %>
  """
  def live_modal(socket, component, opts) do
    path = Keyword.fetch!(opts, :return_to)
    modal_opts = [id: :modal, return_to: path, component: component, opts: opts]
    live_component(socket, ScandocWeb.ModalComponent, modal_opts)
  end

  def getPermissionType(id) do
    Permissions.getLevelToString(id)
  end

  def getPermissionRef(type, ref_id) do
    case Permissions.getPermType(type) do
      :allow_all ->
        ""

      :allow_school ->
        case School |> where(id: ^ref_id) |> Repo.one() do
          nil -> "???"
          school -> school.school_name
        end

      :allow_classroom ->
        case Classroom |> where(id: ^ref_id) |> Repo.one() do
          nil ->
            "???"

          classroom ->
            school = School |> where(id: ^classroom.school_id) |> Repo.one()
            "#{school.school_name} / #{classroom.classroom_name} "
        end

      :allow_student ->
        case Student |> where(id: ^ref_id) |> Repo.one() do
          nil -> "???"
          student -> "#{student.full_name}(#{student.student_zehut})"
        end

      :allow_institute ->
        case Institute |> where(id: ^ref_id) |> Repo.one() do
          nil -> "???"
          institute -> "#{institute.title} (#{institute.code})"
        end

      :allow_vendor ->
        "No vendor"

      _ ->
        "????"
    end
  end
end
