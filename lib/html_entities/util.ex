defmodule HtmlEntities.Util do
  @moduledoc """
  Utility functions for managing metadata.

  Putting this code here makes it testable, and allows the code
  generation part of HtmlEntities to be as small as possible.
  """

  @type entity :: {String.t(), String.t(), integer()}

  @doc "Load HTML entities from an external file."
  @spec load_entities(String.t()) :: [entity()]
  def load_entities(filename) do
    File.stream!(filename) |> Enum.map(&convert_line_to_entity/1)
  end

  @doc "Converts a line of comma-separated lines to entity definitions."
  @spec convert_line_to_entity([String.t()] | File.Stream.t()) :: entity()
  def convert_line_to_entity(line) do
    [name, character, codepoint] = line |> String.trim_trailing() |> String.split(",")
    {name, character, String.to_integer(codepoint)}
  end
end
