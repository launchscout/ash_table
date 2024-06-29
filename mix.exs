defmodule AshTable.MixProject do
  use Mix.Project

  def project do
    [
      app: :ash_table,
      version: "0.1.0",
      elixir: "~> 1.14",
      description: "A sortable, paginated table as a LiveView component, that integrates with Ash",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: [
        licenses: ["MIT"],
        links: %{"Github" => "https://github.com/launchscout/ash_table"}
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:phoenix_live_view, "~> 0.20.2"},
      {:ash, "~> 3.0"},
      {:ash_postgres, "~> 2.0"},
      {:ash_phoenix, "~> 2.0"},
      {:ex_doc, ">= 0.0.0"}
    ]
  end
end
