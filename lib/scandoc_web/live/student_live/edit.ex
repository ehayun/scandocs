defmodule ScandocWeb.StudentLive.Edit do
  use ScandocWeb, :live_view

  import Ecto.Query, warn: false
  alias Scandoc.Repo


  alias Scandoc.Students
  alias Scandoc.Students.{StudentComment, StudentContact, Stddoc}
  alias Scandoc.Classrooms
  alias Scandoc.Schools
  alias Scandoc.Tables
  alias Scandoc.Documents.{Docgroup, Doctype}

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, sort_by: nil, pdf_id: nil, doc_path: nil)}
  end

  @impl true
  @spec handle_params(map, any, Phoenix.LiveView.Socket.t()) ::
          {:noreply, Phoenix.LiveView.Socket.t()}
  def handle_params(%{"id" => id}, _, socket) do
    student = Students.get_student!(id)

    dg = Docgroup
         |> where(is_link: true)
         |> Repo.one()

    doctype = Doctype
              |> where(doc_group_id: ^dg.id)
              |> Repo.all()
              |> hd

    cities = Tables.list_cities()
    genders = Tables.list_gender()
    contact_types = Tables.list_contact_types()
    transportations = Tables.list_all_transportations()

    transportations =
      List.insert_at(transportations, 0, %{id: -1, company_name: gettext("Select transportation")})

    healthcares = Tables.list_healthcare()

    classroom_id = if student.classroom_id, do: student.classroom_id, else: -1

    classroom = Classrooms.get_classroom!(classroom_id)
    school_id = if classroom, do: classroom.school_id, else: -1

    schools = Schools.list_schools()
    schools = List.insert_at(schools, 0, %{id: -1, school_name: gettext("Select school")})

    classrooms = Classrooms.list_classrooms(school_id)

    classrooms =
      List.insert_at(classrooms, 0, %{id: -1, classroom_name: gettext("Select classroom")})

    changeset = Students.change_student(student, %{school_id: school_id})
    {
      :noreply,
      socket
      |> assign(:student, Students.get_student!(id))
      |> assign(:tabnum, 1)
      |> assign(doctype_id: doctype.id)
      |> assign(:school_id, school_id)
      |> assign(:contact_types, contact_types)
      |> assign(genders: genders)
      |> assign(transportations: transportations)
      |> assign(schools: schools)
      |> assign(cities: cities)
      |> assign(healthcares: healthcares)
      |> assign(classrooms: classrooms)
      |> assign(:changeset, changeset)
    }
  end


  @impl true
  def handle_event("setTab", %{"tabid" => tabnum}, socket) do
    {:noreply, assign(socket, tabnum: String.to_integer(tabnum))}
  end

  @impl true
  def handle_event("validate", %{"student" => student_params}, socket) do
    old_school_id = if socket.assigns.school_id, do: socket.assigns.school_id, else: -1

    school_id =
      case student_params do
        %{"school_id" => school_id} -> String.to_integer(school_id)
        _ -> socket.assigns.school_id
      end

    socket =
      if old_school_id != school_id do
        classroom_id =
          case student_params do
            %{"classroom_id" => classroom_id} -> classroom_id
            _ -> socket.assigns.classroom_id
          end

        classrooms = Classrooms.list_classrooms(school_id)

        classrooms =
          List.insert_at(classrooms, 0, %{id: -1, classroom_name: gettext("Select classroom")})

        assign(socket, school_id: school_id, classrooms: classrooms, classroom_id: classroom_id)

        changeset =
          socket.assigns.student
          |> Students.change_student(student_params)
          |> Map.put(:action, :validate)
        assign(socket, :changeset, changeset)
      else
        socket
      end

    #     {:noreply, assign(socket, :changeset, changeset)}
    {:noreply, socket}
  end

  @impl true
  def handle_event("save", %{"student" => student_params}, socket) do
    save_student(socket, :edit, student_params)
  end


  @impl true
  def handle_event("add-link", params, socket) do

    existing_docs =
      Map.get(socket.assigns.changeset.changes, :documents, socket.assigns.student.documents)

    IO.inspect(params, label: "params")
    #    IO.inspect(existing_docs, label: "existing_docs")


    documents =
      existing_docs
      |> Enum.concat(
           [
             # NOTE temp_id
             Students.change_student_document(
               %Stddoc{
                 ref_id: socket.assigns.student.id,
                 doctype_id: socket.assigns.doctype_id,
                 temp_id: get_temp_id()
               }
             )
           ]
         )

    changeset =
      socket.assigns.changeset
      |> Ecto.Changeset.put_assoc(:documents, documents)

    {:noreply, assign(socket, changeset: changeset)}

  end

  @impl true
  def handle_event("add-comment", _student_params, socket) do
    existing_comments =
      Map.get(socket.assigns.changeset.changes, :comments, socket.assigns.student.comments)

    comments =
      existing_comments
      |> Enum.concat(
           [
             # NOTE temp_id
             Students.change_student_comment(
               %StudentComment{
                 student_id: socket.assigns.student.id,
                 temp_id: get_temp_id()
               }
             )
           ]
         )

    changeset =
      socket.assigns.changeset
      |> Ecto.Changeset.put_assoc(:comments, comments)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("remove-comment", %{"remove" => remove_id}, socket) do
    IO.inspect(remove_id, label: "remove-comment")
    comments =
      socket.assigns.changeset.changes.comments
      |> Enum.reject(
           fn %{data: comment} ->
             comment.temp_id == remove_id
           end
         )

    changeset =
      socket.assigns.changeset
      |> Ecto.Changeset.put_assoc(:comments, comments)

    {:noreply, assign(socket, changeset: changeset)}
  end

  @impl true
  def handle_event("add-contact", _student_params, socket) do
    existing_contacts =
      Map.get(socket.assigns.changeset.changes, :contacts, socket.assigns.student.contacts)

    contacts =
      existing_contacts
      |> Enum.concat(
           [
             # NOTE temp_id
             Students.change_student_contact(
               %StudentContact{
                 student_id: socket.assigns.student.id,
                 temp_id: get_temp_id()
               }
             )
           ]
         )

    changeset =
      socket.assigns.changeset
      |> Ecto.Changeset.put_assoc(:contacts, contacts)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("remove-contact", %{"remove" => remove_id}, socket) do
    IO.inspect(remove_id, label: "remove-contact")

    contacts =
      socket.assigns.changeset.changes.contacts
      |> Enum.reject(
           fn %{data: contact} ->
             contact.temp_id == remove_id
           end
         )

    changeset =
      socket.assigns.changeset
      |> Ecto.Changeset.put_assoc(:contacts, contacts)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("remove-document", %{"remove" => remove_id}, socket) do
    IO.inspect(remove_id, label: "remove-document")

    documents =
      socket.assigns.changeset.changes.documents
      |> Enum.reject(
           fn %{data: document} ->
             document.temp_id == remove_id
           end
         )

    changeset =
      socket.assigns.changeset
      |> Ecto.Changeset.put_assoc(:documents, documents)

    {:noreply, assign(socket, changeset: changeset)}
  end


  def handle_event("add-commity", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("add-wellfare", _params, socket) do
    {:noreply, socket}
  end

  defp get_temp_id,
       do: :crypto.strong_rand_bytes(5)
           |> Base.url_encode64()
           |> binary_part(0, 5)

  defp save_student(socket, :edit, student_params) do
    {year, _} = Date.year_of_era(Date.utc_today())

    student_params =
      case student_params do
        %{
          "birthdate" => %{
            "day" => _dd,
            "month" => _mm,
            "year" => yy
          }
        } ->
          if String.to_integer(yy) < year - 50 do
            Map.merge(
              student_params,
              %{
                "birthdate" => %{
                  "day" => "0",
                  "month" => "0",
                  "year" => "0"
                }
              }
            )
          else
            student_params
          end

        student_params ->
          student_params
      end

    case Students.update_student(socket.assigns.student, student_params) do
      {:ok, _student} ->
        {
          :noreply,
          socket
          |> push_redirect(to: Routes.student_index_path(socket, :index))
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect(changeset, label: "error save")
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_student(socket, :new, student_params) do
    case Students.create_student(student_params) do
      {:ok, _student} ->
        {
          :noreply,
          socket
          |> push_redirect(to: socket.assigns.return_to)
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
