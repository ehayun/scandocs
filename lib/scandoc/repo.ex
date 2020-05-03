defmodule Scandoc.Repo do
  use Ecto.Repo,
    otp_app: :scandoc,
    adapter: Ecto.Adapters.Postgres
end
