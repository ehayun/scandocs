defmodule ScandocWeb.TransportationLive.FormComponent do
  use ScandocWeb, :live_component

  alias Scandoc.Tables
  alias Scandoc.Transportation.TransportationContact

  @impl true
  def update(%{transportation: transportation} = assigns, socket) do
    changeset = Tables.change_transportation(transportation)
    contact_types = Tables.list_contact_types()

    {:ok,
     socket
     |> assign(assigns)
     |> assign(tabnum: 1)
     |> assign(contact_types: contact_types)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("setTab", %{"tabid" => tabnum}, socket) do
    {:noreply, assign(socket, tabnum: String.to_integer(tabnum))}
  end

  @impl true
  def handle_event("add-contact", _transportation_params, socket) do
    existing_contacts =
      Map.get(socket.assigns.changeset.changes, :contacts, socket.assigns.transportation.contacts)

    IO.inspect(existing_contacts)

    contacts =
      existing_contacts
      |> Enum.concat([
        # NOTE temp_id
        Tables.change_transportation_contact(%TransportationContact{
          transportation_id: socket.assigns.transportation.id,
          temp_id: get_temp_id()
        })
      ])

    changeset =
      socket.assigns.changeset
      |> Ecto.Changeset.put_assoc(:contacts, contacts)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("remove-contact", %{"remove" => remove_id}, socket) do
    contacts =
      socket.assigns.changeset.changes.contacts
      |> Enum.reject(fn %{data: contact} ->
        contact.temp_id == remove_id
      end)

    changeset =
      socket.assigns.changeset
      |> Ecto.Changeset.put_assoc(:contacts, contacts)

    {:noreply, assign(socket, changeset: changeset)}
  end

  @impl true
  def handle_event("validate", %{"transportation" => transportation_params}, socket) do
    changeset =
      socket.assigns.transportation
      |> Tables.change_transportation(transportation_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"transportation" => transportation_params}, socket) do
    save_transportation(socket, socket.assigns.action, transportation_params)
  end

  defp save_transportation(socket, :edit, transportation_params) do
    case Tables.update_transportation(socket.assigns.transportation, transportation_params) do
      {:ok, _transportation} ->
        {:noreply,
         socket
         |> put_flash(:info, gettext("Transportation updated successfully"))
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect(changeset, label: "error")
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_transportation(socket, :new, transportation_params) do
    case Tables.create_transportation(transportation_params) do
      {:ok, _transportation} ->
        {:noreply,
         socket
         |> put_flash(:info, gettext("Transportation created successfully"))
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp get_temp_id, do: :crypto.strong_rand_bytes(5) |> Base.url_encode64() |> binary_part(0, 5)
end
