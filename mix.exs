defmodule HordeConnector.MixProject do
  use Mix.Project

  def project do
    [
      app: :horde_connector,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
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
      {:placebo, "~> 1.1", only: [:dev, :test]},
      {:patiently, "~> 0.2.0", only: :test},
      {:ex_unit_clustered_case, "~> 0.3.2", only: :test, runtime: false},
      {:credo, "~> 0.10", only: [:dev, :test], runtime: false}
    ]
  end

  defp aliases() do
    [
      test: "test --no-start"
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
