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
  @spec decode(String.t()) :: String.t()
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

  defp decode_entity(<<"#x", c, rest::binary>>) when c in ?0..?9 or c in ?a..?f or c in ?A..?F do
    case Integer.parse(<<c, rest::binary>>, 16) do
      {number, ";" <> rest} -> {<<number::utf8>>, rest}
      _ -> :error
    end
  rescue
    ArgumentError -> :error
  end

  defp decode_entity(<<"#", rest::binary>>) do
    case Integer.parse(rest, 10) do
      {number, ";" <> rest} -> {<<number::utf8>>, rest}
      _ -> :error
    end
  rescue
    ArgumentError -> :error
  end

  codes = HtmlEntities.Util.load_entities(@external_resource)

  for {name, _character, codepoint} <- codes do
    defp decode_entity(<<unquote(name), ?;, rest::binary>>) do
      {<<unquote(codepoint)::utf8>>, rest}
    end
  end

  defp decode_entity(_), do: :error

  @doc "Encode HTML entities in a string."
  @spec encode(String.t()) :: String.t()
  def encode(string) do
    encode(string, "")
  end

  defp encode(<<?&, rest::binary>> = entity, acc) do
    case entity do
      <<head::bytes-size(4), remaining::binary>> when head in ["&lt;", "&gt;"] ->
        encode(remaining, acc <> head)

      <<?&, ?a, ?m, ?p, ?;, remaining::binary>> ->
        encode(remaining, acc <> "&amp;")

      <<head::bytes-size(6), remaining::binary>> when head in ["&quot;", "&apos;"] ->
        encode(remaining, acc <> head)

      _ ->
        encode(rest, acc <> encode_entity(?&))
    end
  end

  defp encode(<<head, rest::binary>>, acc) do
    encode(rest, acc <> encode_entity(head))
  end

  defp encode(<<>>, acc), do: acc

  defp encode_entity(?'), do: "&apos;"
  defp encode_entity(?"), do: "&quot;"
  defp encode_entity(?&), do: "&amp;"
  defp encode_entity(?<), do: "&lt;"
  defp encode_entity(?>), do: "&gt;"
  defp encode_entity(other), do: <<other>>
end
