use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :option_calc, OptionCalc.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :option_calc, OptionCalc.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "option_calc_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :option_calc, :option_repo, OptionCalc.Mocks.Repositories.OptionRepositoryMock