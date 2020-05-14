# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :scandoc,
  ecto_repos: [Scandoc.Repo]

# Configures the endpoint
config :scandoc, ScandocWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "+DUa+/mARG3nlIKTtkMxkmlugsWMh0f5XHmrDP7C56248rVzNTLcpsgGzcrI/ASc",
  render_errors: [view: ScandocWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Scandoc.PubSub,
  live_view: [signing_salt: "dLjpvoJ0"]

config :scandoc, ScandocWeb.Gettext, locales: ~w(en he), default_locale: "he"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :phoenix_bootstrap_form,
  translate_error_function: &ScandocWeb.ErrorHelpers.translate_error/1

config :turbo_ecto, Turbo.Ecto,
  repo: Scandoc.Repo,
  per_page: 10

config :scrivener_phoenix,
  left: 0,
  right: 0,
  window: 4,
  outer_window: 0,
  inverted: false,
  param_name: :page,
  template: Scrivener.Phoenix.Template.Bootstrap4,
  labels: %{
    first: "",
    prev: "",
    next: "",
    last: ""
  }

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
