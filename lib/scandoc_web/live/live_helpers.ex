defmodule ScandocWeb.LiveHelpers do
  import Phoenix.LiveView.Helpers

  import Scrivener.PhoenixView

  import Ecto.Query
  alias Scandoc.Repo

  alias Scandoc.Schools.School
  alias Scandoc.Classrooms.Classroom
  alias Scandoc.Students.Student

  alias Scandoc.Documents.Docgroup

  def getDocGroup(id) do
    case Docgroup |> where(id: ^id) |> Repo.one() do
      nil -> ""
      g -> g.grp_name
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
    case id do
      0 -> "ללא הגבלה"
      1 -> "הרשאת בית ספר"
      2 -> "הרשאת כיתה"
      3 -> "הרשאת תלמיד"
      _ -> "לא ידוע"
    end
  end

  def getPermissionRef(type, ref_id) do
    case type do
      0 ->
        ""

      1 ->
        case School |> where(id: ^ref_id) |> Repo.one() do
          nil -> "???"
          school -> school.school_name
        end

      2 ->
        case Classroom |> where(id: ^ref_id) |> Repo.one() do
          nil ->
            "???"

          classroom ->
            school = School |> where(id: ^classroom.school_id) |> Repo.one()
            "#{school.school_name} / #{classroom.classroom_name} "
        end

      3 ->
        case Student |> where(id: ^ref_id) |> Repo.one() do
          nil -> "???"
          student -> "#{student.full_name}(#{student.student_zehut})"
        end

      _ ->
        "Wait"
    end
  end
end
