defmodule HtmlEntities.Mixfile do
  use Mix.Project

  def project do
    [
      app: :html_entities,
      version: "0.4.0",
      name: "HtmlEntities",
      source_url: "https://github.com/martinsvalin/html_entities",
      elixir: "~> 1.3",
      description: description(),
      package: package(),
      deps: deps()
    ]
  end

  defp description do
    """
    Decode and encode HTML entities in a string.
    """
  end

  defp package do
    [
      maintainers: ["Martin Svalin", "Dávid Kovács", "Johan Wärlander"],
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/martinsvalin/html_entities"}
    ]
  end

  defp deps do
    [
      {:earmark, "~> 1.2", only: :dev},
      {:ex_doc, "~> 0.16", only: :dev}
    ]
  end

  def application do
    [applications: []]
  end
end
