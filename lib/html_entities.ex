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
    decode(string, "")
  end

  defp decode(<<"&", rest::binary>>, acc) do
    case decode_entity(rest) do
      {character, rest} -> decode(rest, <<acc::binary, character::binary>>)
      :error -> decode(rest, <<acc::binary, ?&>>)
    end
  end

  defp decode(<<head, rest::binary>>, acc) do
    decode(rest, <<acc::binary, head>>)
  end

  defp decode(<<>>, acc) do
    acc
  end

  defp decode_entity(<<"#x", c, rest::binary>>) when c in ?0..?9 do
    case Integer.parse(<<c, rest::binary>>, 16) do
      {number, ";" <> rest} -> {<<number::utf8>>, rest}
      _ -> :error
    end
  end

  defp decode_entity(<<"#", rest::binary>>) do
    case Integer.parse(rest, 10) do
      {number, ";" <> rest} -> {<<number::utf8>>, rest}
      _ -> :error
    end
  end

  codes = HtmlEntities.Util.load_entities(@external_resource)

  for {name, character, _codepoint} <- codes do
    defp decode_entity(<<unquote(name), ?;, rest::binary>>), do: {unquote(character), rest}
  end

  defp decode_entity(_), do: :error

  @doc "Encode HTML entities in a string."
  @spec encode(String.t) :: String.t
  def encode(string) do
    for <<x <- string>>, into: "" do
      case x do
        ?' -> "&apos;"
        ?" -> "&quot;"
        ?& -> "&amp;"
        ?< -> "&lt;"
        ?> -> "&gt;"
        _ -> <<x>>
      end
    end
  end
end
