defmodule JWTex.Mixfile do
  use Mix.Project

  def project do
    [app: :jwtex,
     version: "0.0.1",
     elixir: "~> 1.0",
     description: "JWT decoding library for Elixir",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps,
     package: package]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger]]
  end

  def package do
    [
      contributors: ["Michael Schaefermeyer"],
      licenses: ["MIT"],
      links: %{"Github" => "http://github.com/mschae/jwtex"}
    ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [
      {:poison, "~> 1.3.0"}
    ]
  end
end
