defmodule Easypost.Mixfile do
  use Mix.Project

  def project do
    [
      app: :easypost,
      version: "0.0.1",
      elixir: "~> 1.5",
      deps: deps(),
      package: [
        files: ["lib", "mix.exs", "README*", "LICENSE*"],
        maintainers: ["Dania Simmons"],
        licenses: ["MIT"],
        links: %{github: "https://github.com/Dania02525/easypost"}
      ],
      description: """
      Elixir Easypost Client
      """
    ]
  end

# Configuration for the OTP application
#
# Type `mix help compile.app` for more information

  def application do
    [applications: [:logger, :inets]]
  end

  defp deps do
    [
      {:poison, ">= 1.5.0"},
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false},
      {:ex_doc, "~> 0.10", only: :dev},
      {:earmark, ">= 0.0.0"}
    ]
  end
end
