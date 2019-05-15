defmodule HordeConnector.MixProject do
  use Mix.Project

  def project do
    [
      app: :horde_connector,
      version: "0.1.1",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: docs(),
      description: description(),
      aliases: aliases(),
      package: package(),
      source_url: "https://github.com/smartcitiesdata/horde_connector",
      elixirc_paths: elixirc_paths(Mix.env())
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:horde, "~> 0.2.3"},
      {:placebo, "~> 1.2.1", only: [:dev, :test]},
      {:patiently, "~> 0.2.0", only: :test},
      {:ex_doc, "~> 0.19", only: [:dev, :test], runtime: false},
      {:ex_unit_clustered_case, "~> 0.3.2", only: :test, runtime: false},
      {:credo, "~> 1.0", only: [:dev, :test], runtime: false}
    ]
  end

  defp description() do
    "Automatically connects configured hordes on nodeup events"
  end

  defp docs do
    [
      main: "readme",
      source_url: "https://github.com/smartcitiesdata/horde_connector",
      extras: [
        "README.md"
      ]
    ]
  end

  defp aliases() do
    [
      test: "test --no-start"
    ]
  end

  defp package() do
    [
      maintainers: ["smartcitiesdata"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/smartcitiesdata/horde_connector"}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
