defmodule HtmlEntities do
  @moduledoc """
  Decode HTML entities in a string.

  ## Examples

      iex> "Tom &amp; Jerry" |> HtmlEntities.decode
      "Tom & Jerry"
      iex> "&#161;Ay, caramba!" |> HtmlEntities.decode
      "¡Ay, caramba!"
      iex> "&#337; &#x151;" |> HtmlEntities.decode
      "ő ő"
  """

  @external_resource "lib/html_entities_list.txt"

  @doc "Decode HTML entities in a string."
  @spec decode(String.t) :: String.t
  def decode(string) do
    Regex.replace(~r/\&([^\s]+);/r, string, &replace_entity/2)
  end

  codes = File.stream!(@external_resource) |> Enum.reduce [], fn(line, acc) ->
    [name, character, codepoint] = line |> String.rstrip |> String.split ","
    :lists.keystore(name, 1, acc, {name, character, codepoint})
  end

  for {name, character, codepoint} <- codes do
    defp replace_entity(_, unquote(name)), do: unquote(character)
    defp replace_entity(_, unquote(codepoint)), do: unquote(character)
  end

  defp replace_entity(original, "#x" <> code) do
    try do
      << String.to_integer(code, 16) :: utf8 >>
    rescue ArgumentError -> original end
  end

  defp replace_entity(original, "#" <> code) do
    try do
      << String.to_integer(code) :: utf8 >>
    rescue ArgumentError -> original end
  end

  defp replace_entity(original, _), do: original
end
