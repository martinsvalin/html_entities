HtmlEntities
============

Elixir module for decoding HTML entities in a string.

Entity names, codepoints and their corresponding characters are copied from
[Wikipedia](https://en.wikipedia.org/wiki/List_of_XML_and_HTML_character_entity_references).

## Adding to your `mix.exs`

```elixir
defp deps do
    [{:html_entities, "~> 0.1"}]
end
```

## Usage

Inside iex:
```elixir
    iex> HtmlEntities.decode("Tom &amp; Jerry")
    "Tom & Jerry"
    iex> HtmlEntities.decode("&#161;Ay, caramba!")
    "¡Ay, caramba!"
```

Inside a module:
```elixir
defmodule EntityTest do
    require HtmlEntities

    def myfunction do
        HtmlEntities.decode("&#161;")
    end
end
