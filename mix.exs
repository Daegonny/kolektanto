defmodule Kolektanto.MixProject do
  use Mix.Project

  def project do
    [
      app: :kolektanto,
      version: "0.1.0",
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Kolektanto.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:ecto_sql, "~> 3.6"},
      {:ex_machina, "~> 2.7.0", only: :test},
      {:faker, "~> 0.17"},
      {:jason, "~> 1.2"},
      {:hammox, "~> 0.7", only: :test},
      {:open_api_spex, "~> 3.19"},
      {:phoenix, "~> 1.7.3"},
      {:phoenix_ecto, "~> 4.4"},
      {:phoenix_live_dashboard, "~> 0.6"},
      {:phoenix_view, "~> 2.0"},
      {:plug_cowboy, "~> 2.5"},
      {:postgrex, ">= 0.0.0"},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "doc.build": ["openapi.spec.json --spec KolektantoWeb.ApiSpec --pretty"]
    ]
  end
end
