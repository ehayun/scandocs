defmodule ScandocWeb.CityLive.FormComponent do
  use ScandocWeb, :live_component

  alias Scandoc.Tables
  alias Scandoc.City.{CityAddress, CityContact}

  @impl true
  def update(%{city: city} = assigns, socket) do
    districts = Tables.list_districts()
    districts = List.insert_at(districts, 0, %{id: -1, district_name: gettext("Select district")})
    contact_types = Tables.list_contact_types()

    changeset = Tables.change_city(city)

    {
      :ok,
      socket
      |> assign(assigns)
      |> assign(tabnum: 1)
      |> assign(districts: districts)
      |> assign(contact_types: contact_types)
      |> assign(:changeset, changeset)
    }
  end

  @impl true
  def handle_event("setTab", %{"tabid" => tabnum}, socket) do
    {:noreply, assign(socket, tabnum: String.to_integer(tabnum))}
  end

  @impl true
  def handle_event("add-contact", _city_params, socket) do
    existing_contacts =
      Map.get(socket.assigns.changeset.changes, :contacts, socket.assigns.city.contacts)

    contacts =
      existing_contacts
      |> Enum.concat([
        # NOTE temp_id
        Tables.change_city_contact(%CityContact{
          city_id: socket.assigns.city.id,
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
  def handle_event("add-address", _city_params, socket) do
    existing_addresses =
      Map.get(socket.assigns.changeset.changes, :addresses, socket.assigns.city.addresses)

    addresses =
      existing_addresses
      |> Enum.concat([
        # NOTE temp_id
        Tables.change_city_address(%CityAddress{
          city_id: socket.assigns.city.id,
          temp_id: get_temp_id()
        })
      ])

    changeset =
      socket.assigns.changeset
      |> Ecto.Changeset.put_assoc(:addresses, addresses)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("remove-address", %{"remove" => remove_id}, socket) do
    addresses =
      socket.assigns.changeset.changes.addresses
      |> Enum.reject(fn %{data: contact} ->
        contact.temp_id == remove_id
      end)

    changeset =
      socket.assigns.changeset
      |> Ecto.Changeset.put_assoc(:addresses, addresses)

    {:noreply, assign(socket, changeset: changeset)}
  end



  @impl true
  def handle_event("validate", %{"city" => city_params}, socket) do
    changeset =
      socket.assigns.city
      |> Tables.change_city(city_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"city" => city_params}, socket) do
    save_city(socket, socket.assigns.action, city_params)
  end

  defp save_city(socket, :edit, city_params) do
    case Tables.update_city(socket.assigns.city, city_params) do
      {:ok, _city} ->
        {
          :noreply,
          socket
          #  |> put_flash(:info, gettext("City updated successfully"))
          |> push_redirect(to: socket.assigns.return_to)
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect(changeset)

        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_city(socket, :new, city_params) do
    case Tables.create_city(city_params) do
      {:ok, _city} ->
        {
          :noreply,
          socket
          #  |> put_flash(:info, gettext("City created successfully"))
          |> push_redirect(to: socket.assigns.return_to)
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect(changeset)
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp get_temp_id,
    do:
      :crypto.strong_rand_bytes(5)
      |> Base.url_encode64()
      |> binary_part(0, 5)
end
