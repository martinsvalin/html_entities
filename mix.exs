defmodule HtmlEntities.Mixfile do
  use Mix.Project

  def project do
    [
      app: :html_entities,
      version: "0.1.0",
      name: "HtmlEntities",
      source_url: "https://github.com/martinsvalin/html_entities",
      elixir: "~> 1.0",
      description: description,
      package: package,
      deps: deps
    ]
  end

  defp description do
    """
    Decode HTML entities in a string.
    """
  end

  defp package do
    [
      contributors: ["Martin Svalin"],
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/martinsvalin/html_entities"}
    ]
  end

  defp deps do
    []
  end

  def application do
    [applications: []]
  end
end
