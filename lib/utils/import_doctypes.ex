defmodule Scandoc.Util.ImportDoctypes do
  import Ecto.Query, warn: false
  alias Scandoc.Repo

  alias Scandoc.Documents
  #alias Scandoc.Documents.Doctype
  alias Scandoc.Documents.Docgroup

  def run() do
    grps = [
      %{id: 1, grp_name: "מסמכים בסיסיים"},
      %{id: 2, grp_name: "סיכומים"},
      %{id: 3, grp_name: "השמות ושיבוצים"},
      %{id: 4, grp_name: "תעודת והוואי"},
      %{id: 5, grp_name: "מכתבים יוצאים"},
      %{id: 6, grp_name: "מכתבים נכנסים"},
      %{id: 100, grp_name: "חשבוניות "},
      %{id: 200, grp_name: "דפי בנק "},
      %{id: 300, grp_name: "אישורי יתרה "}
    ]

    for g <- grps do
      case Docgroup |> where(id: ^g.id) |> Repo.one() do
        nil ->
          Documents.create_docgroup(g)

        _ ->
          nil
      end
    end

    #filename = "./storage/doctypes.csv"
    # import_from_csv(filename)
  end

  #defp import_from_csv(csv_path) do
  #  CSVLixir.read(csv_path) |> Enum.to_list() |> Enum.each(fn line -> _process_csv_row(line) end)
  #end

#  defp _process_csv_row(row) do
#    [code, doc_group, doc_name, note] = row
#
#    params = %{
#      code: code,
#      doc_name: doc_name,
#      doc_group_id: doc_group,
#      doc_notes: "#{note}" |> String.trim()
#    }
#
#    # IO.inspect(params)
#    # Accounts.register_user(user_params)
#    case Doctype |> where(code: ^code) |> Repo.one() do
#      nil ->
#        Documents.create_doctype(params)
#
#      doc ->
#        Documents.update_doctype(doc, params)
#    end
#  end

  # EOF
end
