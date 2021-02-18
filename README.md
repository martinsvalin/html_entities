# HtmlEntities

[![Module Version](https://img.shields.io/hexpm/v/html_entities.svg)](https://hex.pm/packages/html_entities)
[![Hex Docs](https://img.shields.io/badge/hex-docs-lightgreen.svg)](https://hexdocs.pm/html_entities/)
[![Total Download](https://img.shields.io/hexpm/dt/html_entities.svg)](https://hex.pm/packages/html_entities)
[![License](https://img.shields.io/hexpm/l/html_entities.svg)](https://github.com/martinsvalin/html_entities/blob/master/LICENSE)
[![Last Updated](https://img.shields.io/github/last-commit/martinsvalin/html_entities.svg)](https://github.com/martinsvalin/html_entities/commits/master)

Elixir module for decoding and encoding HTML entities in a string.

Entity names, codepoints and their corresponding characters are copied from
[Wikipedia](https://en.wikipedia.org/wiki/List_of_XML_and_HTML_character_entity_references).

## Installation

Add the dependency to your `mix.exs` file, then run `mix deps.get`.

```elixir
defp deps do
  [
    {:html_entities, "~> 0.5"}
  ]
end
```

## Usage

Inside IEx:

```elixir
iex> HtmlEntities.decode("Tom &amp; Jerry")
"Tom & Jerry"
iex> HtmlEntities.decode("&#161;Ay, caramba!")
"¡Ay, caramba!"
iex> HtmlEntities.encode("<< KAPOW!! >>")
"&lt;&lt; KAPOW!! &gt;&gt;"
```

Inside a module:

```elixir
defmodule EntityTest do
  def non_breaking_space do
    HtmlEntities.decode("&#161;")
  end
end
```

## License

Copyright (c) 2015 Martin Svalin

This library is MIT licensed. See the [LICENSE](https://github.com/martinsvalin/html_entities/blob/master/LICENSE) for details.
