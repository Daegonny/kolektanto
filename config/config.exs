# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :kolektanto,
  ecto_repos: [Kolektanto.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :kolektanto, KolektantoWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: KolektantoWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Kolektanto.PubSub,
  live_view: [signing_salt: "zaH8j2dP"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :kolektanto, :tags, Kolektanto.Tag.Tags
config :kolektanto, :items, Kolektanto.Item.Items
config :kolektanto, :item_context, Kolektanto.Item.Context

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
