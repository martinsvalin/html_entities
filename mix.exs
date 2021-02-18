defmodule HtmlEntities.Mixfile do
  use Mix.Project

  @source_url "https://github.com/martinsvalin/html_entities"
  @version "0.5.2"

  def project do
    [
      app: :html_entities,
      version: @version,
      name: "HtmlEntities",
      elixir: "~> 1.3",
      description: description(),
      package: package(),
      deps: deps(),
      docs: docs()
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
      links: %{"GitHub" => @source_url}
    ]
  end

  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp docs do
    [
      extras: ["README.md"],
      main: "readme",
      source_url: @source_url,
      source_ref: "v#{@version}"
    ]
  end

  def application do
    [applications: []]
  end
end
