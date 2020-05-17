defmodule ScandocWeb.VendorLive.Index do
  use ScandocWeb, :live_view

  alias Scandoc.Vendors
  alias Scandoc.Vendors.Vendor

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :vendors, fetch_vendors())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, gettext("Edit Vendor"))
    |> assign(:vendor, Vendors.get_vendor!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, gettext("New Vendor"))
    |> assign(:vendor, %Vendor{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, gettext("Listing Vendors"))
    |> assign(:vendor, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    vendor = Vendors.get_vendor!(id)
    {:ok, _} = Vendors.delete_vendor(vendor)

    {:noreply, assign(socket, :vendors, fetch_vendors())}
  end

  defp fetch_vendors do
    Vendors.list_vendors()
  end
end
