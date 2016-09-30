# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :option_calc,
  ecto_repos: [OptionCalc.Repo]

# Configures the endpoint
config :option_calc, OptionCalc.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "dTtKGkLutmOXFO04eeopqjS0gQ7SZSUtqKjKf5CbKS57DklNioQRhQOhp6nat4WP",
  render_errors: [view: OptionCalc.ErrorView, accepts: ~w(html json)],
  pubsub: [name: OptionCalc.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
import_config "secrets.exs"