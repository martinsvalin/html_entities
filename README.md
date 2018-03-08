HtmlEntities
============

Elixir module for decoding and encoding HTML entities in a string.

Entity names, codepoints and their corresponding characters are copied from
[Wikipedia](https://en.wikipedia.org/wiki/List_of_XML_and_HTML_character_entity_references).

## Installation

Add the dependency to your `mix.exs` file, then run `mix deps.get`.

```elixir
defp deps do
  [{:html_entities, "~> 0.4"}]
end
```

## Usage

Inside iex:

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
