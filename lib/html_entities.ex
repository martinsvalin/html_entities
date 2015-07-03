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

  @doc "Decode HTML entities in a string."
  @spec decode(String.t) :: String.t
  def decode(string) do
    Regex.replace(~r/\&([^\s]+);/r, string, &replace_entity/2)
  end

  html_entities_list_path = Path.join(__DIR__, "html_entities_list.txt")

  codes = File.stream!(html_entities_list_path) |> Enum.reduce [], fn(line, acc) ->
    [name, character, codepoint] = :binary.split(line, ",", [:global])
    :lists.keystore(name, 1, acc, {name, character, String.rstrip(codepoint)})
  end

  for {name, character, codepoint} <- codes do
    defp replace_entity(_, unquote(name)), do: unquote(character)
    defp replace_entity(_, unquote(codepoint)), do: unquote(character)
  end

  defp replace_entity(_, "#x" <> code) do
    << String.to_integer(code, 16) :: utf8 >>
  end

  defp replace_entity(_, "#" <> code) do
    << String.to_integer(code) :: utf8 >>
  end

  defp replace_entity(match, _), do: match
end
