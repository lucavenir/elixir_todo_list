defmodule Todo.MixProject do
  use Mix.Project

  def project do
    [
      app: :todo,
      version: "0.1.1",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      compilers: [:yecc] ++ Mix.compilers()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Todo.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:dialyxir, "~> 1.4.3", only: [:dev, :test], runtime: false}
    ]
  end
end
