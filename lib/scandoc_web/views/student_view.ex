defmodule ScandocWeb.StudentView do
  use ScandocWeb, :view

  import Ecto.Query, warn: false
  alias Scandoc.Repo

  alias Scandoc.Documents.Docgroup

  def getDocGroup(id) do
    case Docgroup |> where(id: ^id) |> Repo.one() do
      nil -> ""
      g -> g.grp_name
    end
  end
end
