defmodule ScandocWeb.PhoneLive.Index do
  use ScandocWeb, :live_view

  alias Scandoc.Customers
  alias Scandoc.Customers.Phone

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :phones, fetch_phones())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Phone")
    |> assign(:phone, Customers.get_phone!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Phone")
    |> assign(:phone, %Phone{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Phones")
    |> assign(:phone, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    phone = Customers.get_phone!(id)
    {:ok, _} = Customers.delete_phone(phone)

    {:noreply, assign(socket, :phones, fetch_phones())}
  end

  defp fetch_phones do
    Customers.list_phones()
  end
end
