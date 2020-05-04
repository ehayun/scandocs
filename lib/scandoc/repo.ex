defmodule Scandoc.Repo do
  use Ecto.Repo,
    otp_app: :scandoc,
    adapter: Ecto.Adapters.Postgres

  use Scrivener, page_size: 10
end
