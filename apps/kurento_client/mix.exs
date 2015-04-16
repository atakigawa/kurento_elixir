defmodule KC.Mixfile do
  use Mix.Project

  def project do
    [app: :kurento_client,
     version: "0.0.1",
     deps_path: "../../deps",
     lockfile: "../../mix.lock",
     elixir: "~> 1.0",
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger],
     mod: {KC, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # To depend on another app inside the umbrella:
  #
  #   {:myapp, in_umbrella: true}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [
      {:"socket",
        git: "https://github.com/meh/elixir-socket.git",
        ref: "1d1a85031e862dbf1d17f1c867a5871bc52e95da"},
      {:"jiffy",
        git: "https://github.com/davisp/jiffy.git",
        ref: "801f9e72995eb72b303018885137ad8afbf1fb2b"},
    ]
  end
end
