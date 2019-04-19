defmodule HtmlEntities do
  @moduledoc """
  Decode and encode HTML entities in a string.

  ## Examples

  Decoding:

      iex> "Tom &amp; Jerry" |> HtmlEntities.decode
      "Tom & Jerry"
      iex> "&#161;Ay, caramba!" |> HtmlEntities.decode
      "¡Ay, caramba!"
      iex> "&#337; &#x151;" |> HtmlEntities.decode
      "ő ő"

  Encoding:

      iex> "Tom & Jerry" |> HtmlEntities.encode
      "Tom &amp; Jerry"
      iex> "<< KAPOW!! >>" |> HtmlEntities.encode
      "&lt;&lt; KAPOW!! &gt;&gt;"
  """

  @external_resource "lib/html_entities_list.txt"

  @doc "Decode HTML entities in a string."
  @spec decode(String.t) :: String.t
  def decode(string) do
    Regex.replace(~r/\&([^\s]+);/U, string, &replace_entity/2)
  end

  @doc "Encode HTML entities in a string."
  @spec encode(String.t) :: String.t
  def encode(string) do
    String.graphemes(string)
    |> Enum.map(&replace_character/1)
    |> Enum.join()
  end

  # From https://github.com/rails/rails/blob/master/activesupport%2Flib%2Factive_support%2Fcore_ext%2Fstring%2Foutput_safety.rb
  @html_escape_once_regexp ~r/["><']|&(?!([a-zA-Z]+|(#\d+)|(#[xX][\dA-Fa-f]+));)/
  @doc "Encode HTML entities in a string ensuring entities are not double encoded (ex: &amp;amp;)."
  @spec encode_once(String.t) :: String.t
  def encode_once(string) do
    Regex.replace(@html_escape_once_regexp, string, &replace_character/1)
  end

  codes = HtmlEntities.Util.load_entities(@external_resource)

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

  defp replace_character("'"), do: "&#39;"
  defp replace_character("\""), do: "&quot;"
  defp replace_character("&"), do: "&amp;"
  defp replace_character("<"), do: "&lt;"
  defp replace_character(">"), do: "&gt;"
  defp replace_character(original), do: original
end
