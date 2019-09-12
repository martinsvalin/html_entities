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

## USAGE

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

#QUESTIONS

**How does your solution perform?**
 - My solution performs really well for most operations required by this simple use, allowing me to put jobs in the background in the same thread to avoid creating a lot of threads increasing the hardware use. I also used Docker to help us with the process of deployment.

**How does your solution scale?**
  - My solution uses Sideqik which is a faster job system, allowing me to execute jobs effitently jobs in background avoid blocking operations. With that we could have a better use of our Hardware by putting jobs to run in background to avoid long processing operations during request making the user wait longer.
 
 **What would you improve next?**
 - I would make a better use of Redis to cache most of the trivial requests, allowing a faster response to the users.
