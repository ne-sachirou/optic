defmodule Optic.Mixfile do
  use Mix.Project

  def project do
    [
      app: :optic,
      version: "0.1.0",
      elixir: "~> 1.4",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps(),
      aliases: aliases(),
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:credo, "~> 0.7", only: [:dev, :test]},
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false},
    ]
  end

  defp aliases do
    [
      lint: ["credo", "dialyzer --halt-exit-status"],
      validate: &validate/1,
    ]
  end

  defp validate(_opts) do
    exit_status = [
      ["credo"],
      ["dialyzer", "--halt-exit-status"],
      ["test", "--color"],
    ]
    |> Enum.map(&(Task.async fn -> System.cmd "mix", &1, into: IO.stream(:stdio, :line) end))
    |> Enum.map(&(&1 |> Task.await |> elem(1)))
    |> Enum.max
    exit {:shutdown, exit_status}
  end
end
