defmodule Tgapi.MixProject do
  use Mix.Project

  def project do
    [
      app: :tgapi,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: "Telegram Bot API Framework wrote in Elixir to provide a lightweight and solid system to avoid any crash.",
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      applications: [:httpoison, :json, :tesla]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.8"},
      {:tesla, "~> 1.4"},
      {:hackney, "~> 1.13"},
      {:json, "~> 1.4"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp package() do
    [
      licenses: ["GPL-3.0-only"],
      links: %{"GitHub" => "https://github.com/witer33/elixirtgapi"}
    ]
  end
end
