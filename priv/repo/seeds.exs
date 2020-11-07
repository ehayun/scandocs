# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Scandoc.Repo.insert!(%Scandoc.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

import Ecto.Query, warn: false
alias Scandoc.Repo

alias Scandoc.Documents
alias Scandoc.Documents.Docgroup

dg = Docgroup
     |> where(is_link: true)
     |> Repo.one

case dg do
  nil ->
    Documents.create_docgroup(%{id: 999, grp_name: "קישורים", is_link: true})
    Documents.create_doctype(%{code: "901", doc_name: "קישור", doc_group_id: 999})
  _ -> nil
end