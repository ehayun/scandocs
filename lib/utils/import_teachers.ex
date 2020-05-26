defmodule Scandoc.Util.ImportTeachers do
  # alias Scandoc.Schools
  alias Scandoc.Accounts

  # alias Scandoc.Repo

  def run() do
    filename = "./storage/teachers.csv"
    import_from_csv(filename)
  end

  def import_from_csv(csv_path) do
    File.stream!(Path.expand(csv_path))
    |> CSV.decode(separator: ?;, headers: false)
    |> Stream.each(fn row ->
      _process_csv_row(row)
    end)
    |> Stream.run()
  end

  defp _process_csv_row(row) do
    {:ok, row} = row
    [row] = row
    [zehut, dob, _y, p, full_name, _, _] = String.split(row, ",")

    [dd, mm, yyyy] = String.split(dob, "/")

    {:ok, d} =
      Date.from_erl({String.to_integer(yyyy), String.to_integer(mm), String.to_integer(dd)})

    user_params = %{
      full_name: full_name,
      date_of_birth: d,
      zehut: zehut,
      role: "030",
      password: p
    }

    # IO.inspect(user_params)
    Accounts.register_user(user_params)
  end

  # EOF
end
