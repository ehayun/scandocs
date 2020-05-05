defmodule ScandocWeb.LiveHelpers do
  import Phoenix.LiveView.Helpers

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
end
