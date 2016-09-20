# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :todoapp,
  ecto_repos: [Todoapp.Repo]

# Configures the endpoint
config :todoapp, Todoapp.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "0EgEh2kEVJWD1XfKgXKIwjh6afrKkvOctinNZC34kCP0jArNerPS4MhOLVFkrGWv",
  render_errors: [view: Todoapp.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Todoapp.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :ueberauth, Ueberauth,
  providers: [
    google: {Ueberauth.Strategy.Google, []},
    github: {Ueberauth.Strategy.Github, []}
  ]

config :ueberauth, Ueberauth.Strategy.Github.OAuth,
  client_id: System.get_env("GITHUB_CLIENT_ID"),
  client_secret: System.get_env("GITHUB_CLIENT_SECRET"),
  redirect_uri: "http://rxc4044.student.rit.edu:4000/auth/github/callback"

config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id: System.get_env("GOOGLE_CLIENT_ID"),
  client_secret: System.get_env("GOOGLE_CLIENT_SECRET")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
