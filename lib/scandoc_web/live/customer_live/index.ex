defmodule ScandocWeb.CustomerLive.Index do
  use ScandocWeb, :live_view

  alias Scandoc.Customers
  alias Scandoc.Customers.Customer
  alias ScandocWeb.UserAuth

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :users, fetch_users())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, gettext("Edit Customer"))
    |> assign(:customer, Customers.get_customer!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, gettext("New Customer"))
    |> assign(:customer, %Customer{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, gettext("Listing Users"))
    |> assign(:customer, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    customer = Customers.get_customer!(id)
    {:ok, _} = Customers.delete_customer(customer)

    {:noreply, assign(socket, :users, fetch_users())}
  end

  defp fetch_users do
    Customers.list_users()
  end
end
