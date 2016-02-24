defmodule Growlex.Mixfile do
  use Mix.Project

  def project do
    [
      app: app_name,
      version: app_version,
      elixir: "~> 1.2",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps,
      package: package,
      descriptions: description,
      aliases: aliases,
    ]
  end

  def app_name do
    :growlex
  end

  def app_version do
    "0.1.0"
  end

  def package do
    [
      maintainers: ["Joshua Rieken"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/atomic-fads/growlex"},
      files: ~w(LICENSE.md README.md lib mix.exs),
    ]
  end

  def description do
    """
    Growlex is a GNTP (Growl Network Transpot Protocol) 1.0 client written in Elixir.
    """
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    []
  end

  defp aliases do
    [
      "test.setup": ["ecto.create", "ecto.migrate"],
      "test.reset": ["ecto.drop", "test.setup"],
    ]
  end
end
