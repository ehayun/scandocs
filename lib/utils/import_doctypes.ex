defmodule Scandoc.Util.ImportDoctypes do
  alias Scandoc.Documents

  def run() do
    filename = "./storage/doctypes.csv"
    import_from_csv(filename)
  end

  defp import_from_csv(csv_path) do
    CSVLixir.read(csv_path) |> Enum.to_list() |> Enum.each(fn line -> _process_csv_row(line) end)
  end

  defp _process_csv_row(row) do
    [code, doc_name, note, note2] = row

    params = %{
      code: code,
      doc_name: doc_name,
      doc_notes: "#{note} #{note2}" |> String.trim()
    }

    # IO.inspect(params)
    # Accounts.register_user(user_params)
    Documents.create_doctype(params)
  end

  # EOF
end
