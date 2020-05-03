defmodule ScandocWeb.PhoneLive.FormComponent do
  use ScandocWeb, :live_component

  alias Scandoc.Customers

  @impl true
  def update(%{phone: phone} = assigns, socket) do
    changeset = Customers.change_phone(phone)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"phone" => phone_params}, socket) do
    changeset =
      socket.assigns.phone
      |> Customers.change_phone(phone_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"phone" => phone_params}, socket) do
    save_phone(socket, socket.assigns.action, phone_params)
  end

  defp save_phone(socket, :edit, phone_params) do
    case Customers.update_phone(socket.assigns.phone, phone_params) do
      {:ok, _phone} ->
        {:noreply,
         socket
         |> put_flash(:info, "Phone updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_phone(socket, :new, phone_params) do
    case Customers.create_phone(phone_params) do
      {:ok, _phone} ->
        {:noreply,
         socket
         |> put_flash(:info, "Phone created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
